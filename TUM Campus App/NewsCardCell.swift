//
//  NewsCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsCardCell: CardTableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    override func setElement(_ element: DataElement) {
        if let newsItem = element as? News {
            titleLabel.text = newsItem.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a - dd MMM, YYYY"
            dateLabel.text = dateFormatter.string(from: newsItem.date as Date)
            detailImageView.image = newsItem.image
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
