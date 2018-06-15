//
//  News.swift
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

import UIKit
import Sweeft

final class News: DataElement {
    
    let id: String
    let source: Source
    let date: Date
    let title: String
    let link: String
    let imageUrl: String?
    
    init(id: String, source: Source, date: Date, title: String, link: String, imageUrl: String? = nil) {
        self.id = id
        self.source = source
        self.date = date
        self.title = title
        self.link = link
        self.imageUrl = imageUrl
    }
    
    var text: String {
        get {
            return title
        }
    }
    
    func getCellIdentifier() -> String {
        return "news"
    }
    
    func open(sender: UIViewController? = nil) {
        link.url?.open(sender: sender)
    }
    
}

extension News: Deserializable {
    
    convenience init?(from json: JSON) {
        guard let title = json["title"].string,
            let source = json["src"].string.flatMap(Int.init).map(News.Source.init(identifier:)),
            let link = json["link"].string,
            let date = json["date"].date(using: "yyyy-MM-dd HH:mm:ss"),
            let id = json["news"].string else {
            return nil
        }
        self.init(id: id, source: source, date: date, title: title, link: link, imageUrl: json["image"].string)
    }
    
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
