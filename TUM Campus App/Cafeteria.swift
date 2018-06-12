//
//  Cafeteria.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Sweeft
import CoreLocation

final class Cafeteria: DataElement {
    
    let address: String
    let id: String
    let name: String
    var menus = [String : [CafeteriaMenu]]()
    let location: CLLocation
    
    var hasMenuToday: Bool {
        guard let menus = menus[Date.now.dayString] else {
            return false
        }
        return !menus.isEmpty
    }

    init(id: String, name: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func addMenu(_ menu: CafeteriaMenu) {
        let key = menu.date.dayString
        menus[key, default: []].append(menu)
//        menus[key] = menus[key]?.sorted(ascending: \.typeNr)
    }
    
    func getMenusForDate(_ date: Date) -> [CafeteriaMenu] {
        return menus[date.dayString] ?? []
    }
    
    func distance(_ from: CLLocation) -> CLLocationDistance {
        return from.distance(from: location)
    }
    
    func getCellIdentifier() -> String {
        return "cafeteria"
    }
    
    var text: String {
        return name
    }
    
}

extension Cafeteria: Deserializable {
    
    convenience init?(from json: JSON) {
        guard let id = json["id"].string,
            let name = json["name"].string,
            let address = json["address"].string,
            let latitude = json["latitude"].string.flatMap(Double.init),
            let longitude = json["longitude"].string.flatMap(Double.init) else {
            return nil
        }
        
        self.init(id: id,
                  name: name,
                  address: address,
                  latitude: latitude,
                  longitude: longitude)
    }
    
}
