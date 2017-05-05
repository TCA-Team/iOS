//
//  CafeteriaCardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class CafeteriaCardTableViewCell: CardTableViewCell {
    
    @IBOutlet weak var cafeteriaLabel: UILabel!
    @IBOutlet var dish1Label: UILabel!
    @IBOutlet var dish2Label: UILabel!
    @IBOutlet var dish3Label: UILabel!
    @IBOutlet var dish4Label: UILabel!

    override func setElement(_ element: DataElement) {
        if let cafeteria = element as? Cafeteria {
            cafeteriaLabel.text = cafeteria.name
            let items = cafeteria.getMenusForDate(Date()).filter() { (item) in
                return item.id != 0
            }
            var string = ""
            for item in items {
                string += "\u{2022} " + item.name + "\n"
            }
        }
    }
    
    override func isFoldingCell() -> Bool {
         return true
    }

}
