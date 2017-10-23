//
//  TuitionTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import AYSlidingPickerView

class TuitionTableViewController: UITableViewController, DetailView {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    var pickerView = AYSlidingPickerView()
    var barItem: UIBarButtonItem?
    
    var delegate: DetailViewDelegate?
    
    var semesters = [Tuition]()
    
    var currentSemester: Tuition? {
        didSet {
            if let semester = currentSemester {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MMM dd, yyyy"
                deadLineLabel.text = dateformatter.string(from: semester.frist as Date)
                balanceLabel.text = semester.soll + " €"
                title = semester.semester
            }
        }
    }

}

extension TuitionTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        semesters.removeAll()
        for item in data {
            if let semester = item as? Tuition {
                semesters.append(semester)
            }
        }
        currentSemester = semesters.first
        setUpPickerView()
    }
    
}

extension TuitionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        delegate?.dataManager().getTuitionStatus(self)
    }
    
}

extension TuitionTableViewController {
    
    func setUpPickerView() {
        var items = [AnyObject]()
        for semester in semesters {
            let item = AYSlidingPickerViewItem(title: semester.semester) { (did) in
                if did {
                    self.currentSemester = semester
                    self.barItem?.action = #selector(TuitionTableViewController.showSemesters(_:))
                    self.barItem?.image = UIImage(named: "expand")
                    self.tableView.reloadData()
                }
            }
            items.append(item!)
        }
        pickerView = AYSlidingPickerView.sharedInstance()
        pickerView.items = items
        pickerView.mainView = navigationController?.view ?? view
        pickerView.selectedIndex = 0
        pickerView.closeOnSelection = true
        pickerView.didDismissHandler = { self.hideSemesters(nil) }
        barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.plain, target: self, action:  #selector(TuitionTableViewController.showSemesters(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
    func showSemesters(_ send: AnyObject?) {
        pickerView.show()
        barItem?.action = #selector(TuitionTableViewController.hideSemesters(_:))
        barItem?.image = UIImage(named: "collapse")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func hideSemesters(_ send: AnyObject?) {
        pickerView.dismiss()
        barItem?.action = #selector(TuitionTableViewController.showSemesters(_:))
        barItem?.image = UIImage(named: "expand")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}
