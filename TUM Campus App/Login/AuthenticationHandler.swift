//
//  AuthenticationHandler.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/17/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit.UIDevice
import Alamofire
import SWXMLHash
import KeychainAccess
import CoreData

enum LoginError: LocalizedError {
    case missingToken
    case invalidToken
    case tokenNotConfirmed
    case serverError(message: String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Missing token".localized
        case .invalidToken:
            return "Invalid token".localized
        case .tokenNotConfirmed:
            return "Token not confirmed".localized
        case let .serverError(message):
            return message
        case .unknown:
            return "Unknown error".localized
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .tokenNotConfirmed:
            return "Go to TUMOnline and activate the token".localized
        default:
            return nil
        }
    }
}

protocol AuthenticationHandlerDelegate {
    func shouldEnterTumID() -> String?
    func shouldEnableTokenPermissions()
    func shouldActivateToken()
}

/// Handles authentication for TUMOnline, TUMCabe and the MVGAPI
final class AuthenticationHandler: RequestAdapter, RequestRetrier {
    typealias Completion = (Result<String,Error>) -> Void
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    var delegate: AuthenticationHandlerDelegate?
    
    private lazy var coreDataStack = appDelegate.persistentContainer
    private lazy var sessionManager: Session = Session.defaultSession
    
    private static let keychain = Keychain(service: "de.tum.tumonline")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
    
    private(set) var credentials: Credentials? {
        get {
            guard let data = AuthenticationHandler.keychain[data: "credentials"] else { return nil }
            return try? PropertyListDecoder().decode(Credentials.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try! PropertyListEncoder().encode(newValue)
                AuthenticationHandler.keychain[data: "credentials"] = data
            } else {
                AuthenticationHandler.keychain[data: "credentials"] = nil
            }
        }
    }
    
    
    // MARK: - Initialization
    
    public init(delegate: AuthenticationHandlerDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        guard let urlString = urlRequest.url?.absoluteString else { return completion(.success(urlRequest)) }
        var pToken: String?
        
        switch credentials {
        case .tumID(_, let token)?,
             .tumIDAndKey(_, let token, _)?:
            pToken = token
        default:
            break
        }
        
        switch urlString {
        case urlString where TUMOnlineAPI.requiresAuth.contains { urlString.hasSuffix($0) }:
            guard let pToken = pToken else { return completion(.failure(LoginError.missingToken)) }
            do {
                let encodedRequest = try URLEncoding.default.encode(urlRequest, with: ["pToken": pToken])
                return completion(.success(encodedRequest))
            } catch let error {
                return completion(.failure(error))
            }
        case urlString where TUMCabeAPI.requiresAuth.contains { urlString.hasSuffix($0)}:
            return completion(.success(urlRequest))
        case urlString where urlString.hasPrefix(MVGAPI.baseURL):
            urlRequest.addValue(MVGAPI.apiKey, forHTTPHeaderField: "X-MVG-Authorization-Key")
            return completion(.success(urlRequest))
        default:
            return completion(.success(urlRequest))
        }
    }
    
    // MARK: - RequestRetrier

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock() ; defer { lock.unlock() }

        var tumID: String
        requestsToRetry.append(completion)

        guard isRefreshing else {
            completion(.doNotRetry)
            return
        }

        switch credentials {
        case .none,
             .noTumID?:
            guard let delegate = delegate else { return }
            guard let id = delegate.shouldEnterTumID() else { return }
            tumID = id
        case .tumID(let id,_)?,
             .tumIDAndKey(let id,_,_)?:
            tumID = id
        }

        createToken(tumID: tumID) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

            switch result {
            case .success(let token):
                // Auth succeeded retry failed request.
                switch strongSelf.credentials {
                case .none: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                case .noTumID?: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                case .tumID(let tumID, _)?: strongSelf.credentials = .tumID(tumID: tumID, token: token)
                case .tumIDAndKey(let tumID, _, let key)?: strongSelf.credentials = .tumIDAndKey(tumID: tumID, token: token, key: key)
                }

            default:
                // Auth failed don't retry.
                break
            }

            strongSelf.requestsToRetry.forEach { $0(.retry) }
            strongSelf.requestsToRetry.removeAll()
        }
    }
    
    // TODO: Migrate data from old tum campus app
    
    func createToken(tumID: String, completion: @escaping Completion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        let tokenName = "TCA - \(UIDevice.current.name)"
        
        sessionManager.request(TUMOnlineAPI.tokenRequest(tumID: tumID, tokenName: tokenName))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/xml"])
            .responseXML { [weak self] xml in
            guard let strongSelf = self else { return }
            guard let newToken = xml.value?["token"].element?.text else {
                strongSelf.isRefreshing = false
                if let errorMessage = xml.value?["error"]["message"].element?.text {
                    return completion(.failure(LoginError.serverError(message: errorMessage)))
                }
                return completion(.failure(LoginError.unknown))
            }
            strongSelf.credentials = Credentials.tumID(tumID: tumID, token: newToken)
            strongSelf.isRefreshing = false
            completion(.success(newToken))
        }
    }
    
    func confirmToken(callback: @escaping (Result<Bool,Error>) -> Void) {
        switch credentials {
        case .none: callback(.failure(LoginError.missingToken))
        case .noTumID?: callback(.failure(LoginError.missingToken))
        case .tumID?,
             .tumIDAndKey?:
            sessionManager.request(TUMOnlineAPI.tokenConfirmation)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["text/xml"])
                .responseXML { xml in
                    if let error = xml.error {
                        callback(.failure(error))
                    } else if xml.value?["confirmed"].element?.text == "true" {
                        callback(.success(true))
                    } else if xml.value?["confirmed"].element?.text == "false" {
                        callback(.failure(LoginError.tokenNotConfirmed))
                    } else {
                        callback(.failure(LoginError.unknown))
                    }
            }
        }
    }
    
    func logout() {
        credentials = nil
        
        let fetchRequests = [
            Grade.fetchRequest(),
            Lecture.fetchRequest(),
            CalendarEvent.fetchRequest(),
            Profile.fetchRequest(),
            Tuition.fetchRequest(),
            TicketEvent.fetchRequest(),
            TicketPayment.fetchRequest(),
            TicketType.fetchRequest(),
        ]
        
        let deleteRequests = fetchRequests.map{ NSBatchDeleteRequest(fetchRequest: $0) }
        deleteRequests.forEach { _ = try? coreDataStack.persistentStoreCoordinator.execute($0, with: coreDataStack.viewContext) }
    }
    
    func skipLogin() {
        credentials = .noTumID
    }

}
