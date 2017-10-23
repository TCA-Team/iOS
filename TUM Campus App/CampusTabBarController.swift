//
//  CampusTabBarController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class CampusNavigationController: UINavigationController {
    
    var manager: TumDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = TumDataManager()
        manager?.getUserData()
    }

}
