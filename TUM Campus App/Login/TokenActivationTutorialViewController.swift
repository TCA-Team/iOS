//
//  TokenActivationTutorialViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 21.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class TokenActivationTutorialViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage.animatedImageNamed("token_step", duration: 10)
        }
    }
}
