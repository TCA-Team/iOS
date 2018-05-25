//
//  GradesDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 13.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class GradesDataSource: NSObject, TUMDataSource {
    
    var manager: PersonalGradeManager
    let cellType: AnyClass = GradesCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let cardKey: CardKey = .grades
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemVerticalFlowLayout()
    var data: [Grade] = []
    var preferredHeight: CGFloat = 230.0
    
    init(manager: PersonalGradeManager) {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! GradesCollectionViewCell
        let grade = data[indexPath.row]
        
        cell.gradeLabel.text = grade.result
        cell.nameLabel.text = grade.name
        cell.semesterLabel.text = grade.semester
        
        switch Double(grade.result.replacingOccurrences(of: ",", with: "."))  {
        case .some(let grade):
            switch grade {
            case 1.0..<2.0: cell.gradeLabel.textColor = .green
            case 2.0..<3.0: cell.gradeLabel.textColor = .yellow
            case 3.0..<4.0: cell.gradeLabel.textColor = .orange
            default: cell.gradeLabel.textColor = .red
            }
        case .none: break
        }
        
        return cell
    }
    

}
