//
//  TUMCabe.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

enum TUMCabeEndpoint: String, APIEndpoint {
    case movie = "kino/"
    case cafeteria = "mensen/"
    case news = "news/{news}"
    case searchRooms = "roomfinder/room/search/{query}"
    case roomMaps = "roomfinder/room/availableMaps/{room}"
    case mapImage = "roomfinder/room/map/{room}/{id}"
}

class TUMCabeAPI: RootCertificatePinningAPI<TUMCabeEndpoint> {
    
    override var baseHeaders: [String : String] {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            
            return .empty
        }
        return [
            "X-DEVICE-ID": uuid,
            "X-APP-VERSION": Bundle.main.version,
            "X-APP-BUILD": Bundle.main.build,
            "X-OS-VERSION": UIDevice.current.systemVersion,
            "User-Agent": Bundle.main.userAgent,
        ]
    }
    
}
