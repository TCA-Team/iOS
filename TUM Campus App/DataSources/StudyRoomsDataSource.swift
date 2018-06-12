//
//  RoomFinderDataSource.swift
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

class StudyRoomsDataSource: NSObject, TUMDataSource {
    
    var manager: StudyRoomsManager
    var cellType: AnyClass = StudyRoomsCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey = .studyRooms
    var flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemVerticalFlowLayout()
    var data: [StudyRoomGroup] = []
    
    init(manager: StudyRoomsManager) {
        self.manager = manager
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data
            group.leave()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! StudyRoomsCollectionViewCell
        let roomGroup = data[indexPath.row]
        
        let availableRoomsCount = roomGroup.rooms.filter{$0.status == StudyRoomStatus.Free }.count
        
        cell.groupNameLabel.text = roomGroup.name
        cell.availableRoomsLabel.text = String(availableRoomsCount)
        
        switch availableRoomsCount {
        case 0: cell.availableRoomsLabel.backgroundColor = .red
        default: cell.availableRoomsLabel.backgroundColor = .green
        }
        
        return cell
    }
    

}
