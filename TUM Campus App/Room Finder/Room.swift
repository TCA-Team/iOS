//
//  Room.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct Room: Codable {
    /*
     {
        "room_id": "59773",
        "room_code": "5302.TP.208",
        "building_nr": "5302",
        "arch_id": "-1.208@5302",
        "info": "-1.208, Cleanroom\/EI. Mikroskop",
        "address": "Lichtenbergstr.    2(5302), Tiefparterre",
        "purpose": "Labor - Physik",
        "campus": "G",
        "name": "Garching"
     }
     */

    let roomId: String
    let roomCode: String
    let buildingNumber: String
    let id: String
    let info: String
    let address: String
    let purpose: String
    let campusShort: String
    let campus: String

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case roomCode = "room_code"
        case buildingNumber = "building_nr"
        case id = "arch_id"
        case info
        case address
        case purpose
        case campusShort = "campus"
        case campus = "name"
    }

}
