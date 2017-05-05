//
//  SexyEntry.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import SwiftyJSON

// Very Sexy
struct SexyEntry: DataElement {
    
    let name: String
    let link: String
    let descriptionText: String
    
    var text: String {
        return name
    }
    
    func getCellIdentifier() -> String {
        return ""
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 0
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 0
    }
    
}

extension SexyEntry {
    
    func open() {
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
}

extension SexyEntry {
    
    init?(name: String, json: JSON) {
        guard let link = json["target"].string,
            let descriptionText = json["description"].string else {
                
            return nil
        }
        self.init(name: name, link: link, descriptionText: descriptionText)
    }
    
}
