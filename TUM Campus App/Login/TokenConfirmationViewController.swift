//
//  TokenConfirmationViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class TokenConfirmationViewController: UIViewController {
    
    @IBOutlet weak var checkAuthorizationButton: ShadowButton!
    
    
    var loginController: AuthenticationHandler?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    @IBAction func didSelectCheckAuthorization(_ sender: Any) {
        loginController?.confirmToken() { [weak self] result in
            switch result {
            case .success:
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                self?.navigationController?.dismiss(animated: true)
            case let .failure(error):
                self?.checkAuthorizationButton.wiggle()
                let alert = UIAlertController(title: "Authorization Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
