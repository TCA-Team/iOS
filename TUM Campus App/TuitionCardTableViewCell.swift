//
//  TuitionCard.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class TuitionCardTableViewCell: CardTableViewCell {
    
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    
    override func setElement(_ element: DataElement) {
        if let tuitionElement = element as? Tuition {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM dd, yyyy"
            deadLineLabel.text = dateformatter.string(from: tuitionElement.frist as Date)
            balanceLabel.text = tuitionElement.soll + " €"
        }
    }
    
}
