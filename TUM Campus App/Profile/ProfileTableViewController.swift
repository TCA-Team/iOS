//
//  ProfileTableViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLCoder
import MessageUI

final class ProfileTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    typealias ImporterType = Importer<Profile,ProfileAPIResponse,XMLDecoder>
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tumIDLabel: UILabel!
    @IBOutlet private weak var signOutLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!

    private static let endpoint = TUMOnlineAPI.identify
    private static let sortDescriptor = NSSortDescriptor(keyPath: \Profile.surname, ascending: false)
    private let loginController = AuthenticationHandler()
    private let coreDataStack = appDelegate.persistentContainer
    private var versionToggle = true {
        didSet {
            versionLabel.text = versionToggle ? "Version \(Bundle.main.version)" : Bundle.main.build
        }
    }

    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor)

    private enum Section: Int {
        case profile
        case myTUM
        case general
        case contact
        case login
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileTableViewController.toggleVersion))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        versionLabel.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        versionToggle = true
        importer.performFetch(success: {
            DispatchQueue.main.async {
                let context = appDelegate.persistentContainer.viewContext
                let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                if let profile = try? context.fetch(profileRequest).first {
                    self.nameLabel.text = "\(profile.firstname ?? "") \(profile.surname ?? "")"
                    self.tumIDLabel.text = profile.tumID ?? profile.role.rawValue
                }
            }
        })
        
        switch loginController.credentials {
        case .none, .noTumID:
            nameLabel.text = "Not logged in".localized
            signOutLabel.text = "Sign In".localized
            signOutLabel.textColor = .green
        default:
            signOutLabel.text = "Sign Out".localized
            signOutLabel.textColor = .red
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (Section(rawValue: indexPath.section), indexPath.row) {
        case (.myTUM, 0):
            performSegue(withIdentifier: "showTuition", sender: nil)
        case (.general, 0):
            performSegue(withIdentifier: "showTUMSexy", sender: nil)
        case (.contact, 0):
            guard let url = URL(string: "https://testflight.apple.com/join/AlXCNNOS") else { return }
            UIApplication.shared.open(url)
        case (.contact, 1):
            guard let url = URL(string: "https://github.com/TUM-Dev/Campus-iOS") else { return }
            UIApplication.shared.open(url)
        case (.contact, 2):
            guard let url = URL(string: "https://www.tum.app") else { return }
            UIApplication.shared.open(url)
        case (.contact, 3):
            let systemVersion = UIDevice.current.systemVersion
            sendEmail(recipient: "app@tum.de",
                      subject: "[iOS]",
                      body: "<br><br>iOS Version: \(systemVersion) <br> App Version: \(Bundle.main.version) <br> Build Version: \(Bundle.main.build)")
        case (.login, 0):
            loginController.logout()
            presentLoginViewController()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func sendEmail(recipient: String, subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([recipient])
            mailVC.setSubject(subject)
            mailVC.setMessageBody(body, isHTML: true)

            self.present(mailVC, animated: true)
        } else {
            assertionFailure("error can't send mail")
        }
    }
    
    private func presentLoginViewController() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: .main)
        guard let navCon = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let loginViewController = navCon.children.first as? LoginViewController else { return }
        loginViewController.loginController = loginController
        present(navCon, animated: true)
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    // MARK: - Tap

    @objc private func toggleVersion() {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        versionToggle.toggle()
    }

}
