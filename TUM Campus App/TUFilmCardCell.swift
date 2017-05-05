//
//  TUFilmCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class TUFilmCardCell: CardTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func setElement(_ element: DataElement) {
        if let unwrappedMovie = element as? Movie{
            titleLabel.text = unwrappedMovie.text
            let day = String (Calendar.current.component(.day, from: unwrappedMovie.airDate))
            let month = String(Calendar.current.component(.month, from: unwrappedMovie.airDate))
            dateLabel.text = day + "." + month
            posterImageView.image = unwrappedMovie.image ?? UIImage(named: "movie")
            posterImageView.clipsToBounds = true
        }
    }
    
}
