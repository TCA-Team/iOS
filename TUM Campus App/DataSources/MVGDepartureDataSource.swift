//
//  MVGDepartureDataSource.swift
//  Campus
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

class MVGDepartureDataSource: NSObject, UICollectionViewDataSource {
    
    let cellType: AnyClass = MVGDepartureCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = ListFlowLayoutDelegate()
    var data: [Departure] = []
    let cellReuseID = "DepartureCardCell"
    let cardReuseID = "DepartureCard"
    
    init(data: [Departure]) {
        self.data = data

        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(data.count, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID,
                                                      for: indexPath) as! MVGDepartureCollectionViewCell

        cell.configure(with: data[indexPath.row])

        return cell
    }
}
