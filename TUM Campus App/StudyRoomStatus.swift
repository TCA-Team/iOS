//
//  StudyRoomStatus.swift
//  TUM Campus App
//
//  Created by Max Muth on 17.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
enum StudyRoomStatus: String {
    case Free = "frei"
    case Occupied = "belegt"
}

extension StudyRoomStatus {
    var sortIndex: Int {
        switch self {
        case .Free: return 0
        case .Occupied: return 1
        }
    }
}
