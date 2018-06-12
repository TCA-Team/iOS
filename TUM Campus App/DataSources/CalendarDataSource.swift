//
//  CalendarDataSource.swift
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


class CalendarDataSource: NSObject, TUMDataSource {
    
    var manager: CalendarManager
    let cellType: AnyClass = CalendarCollectionViewCell.self
    var data: [CalendarRow] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateSingleItemFlowLayout()
    let dateFormatter = DateFormatter()
    let dateComponentsFormatter = DateComponentsFormatter()
    let preferredHeight: CGFloat = 200.0
    
    init(manager: CalendarManager) {
        self.manager = manager
        self.dateFormatter.dateStyle = .full
        self.dateFormatter.timeStyle = .short
        self.dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        self.dateComponentsFormatter.maximumUnitCount = 2
        self.dateComponentsFormatter.unitsStyle = .full
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data.filter{ $0.start.timeIntervalSinceNow > 0}
            group.leave()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! CalendarCollectionViewCell
        let calendarElement = data[indexPath.row]

        cell.titleLabel.text = calendarElement.title
        cell.dateLabel.text = dateFormatter.string(from: calendarElement.start)
        cell.locationLabel.text = calendarElement.location
        cell.timeLeftLabel.text = "in \(dateComponentsFormatter.string(from: .now, to: calendarElement.start) ?? "")"
        cell.timeLeftLabel.textColor = .red
    
        return cell
    }
    
}
