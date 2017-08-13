//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class GradesTableViewController: UITableViewController, TumDataReceiver, DetailViewDelegate, DetailView  {

    var grades = [Grade]()
    
    var delegate: DetailViewDelegate?
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager(user: nil)
    }
    
    func receiveData(_ data: [DataElement]) {
        grades = data.flatMap() { $0 as? Grade }
        tableView.reloadData()
    }
    
}

extension GradesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.dataManager().getGrades(self)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = "Grades"
    }
    
}

extension GradesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grade") as? GradeTableViewCell ?? GradeTableViewCell()
        cell.grade = grades[indexPath.row]
        return cell
    }
    
}

