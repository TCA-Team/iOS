//
//  News.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class News: ImageDownloader, DataElement {
    
    let id: String
    let date: Date
    let title: String
    let link: String
    
    init(id: String, date: Date, title: String, link: String, image: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.link = link
        super.init()
        if let image = image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) {
            getImage(image)
        }
    }
    
    var text: String {
        get {
            return title
        }
    }
    
    func getCellIdentifier() -> String {
        return "news"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 112
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 412
    }
    
    func open() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension News: CardDisplayable {
    
    var cardKey: CardKey {
        return .news
    }
  
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}
