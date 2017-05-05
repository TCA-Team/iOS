//
//  CalendarRow.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CalendarRow: DataElement {
    var description: String?
    var dtend: Date?
    var dtstart: Date?
    var geo: CLLocation?
    var location: String?
    var status: String?
    var title: String?
    var url: URL?
    
    func getCellIdentifier() -> String {
        return "calendarRow"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 112
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 412
    }
    
    var text: String {
        return title?.components(separatedBy: " (")[0].components(separatedBy: " [")[0] ?? ""
    }
    
}

extension CalendarRow: CardDisplayable {
    
    var cardKey: CardKey {
        return .calendar
    }
    
}
