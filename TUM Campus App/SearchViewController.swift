//
//  SearchViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, DetailView {
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    var delegate: DetailViewDelegate?
    
    var elements = [DataElement]()
    
    var currentElement: DataElement?
    
    var searchManagers: [TumDataItems]?

}

extension SearchViewController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager {
        return delegate?.dataManager() ?? TumDataManager()
    }
    
}

extension SearchViewController: TumDataReceiver, ImageDownloadSubscriber {
    
    func receiveData(_ data: [DataElement]) {
        elements = data
        for element in elements {
            if let downloader = element as? ImageDownloader {
                downloader.subscribeToImage(self)
            }
        }
        tableView.reloadData()
    }
    
    func updateImageView() {
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != " " {
            for element in elements {
                if let downloader = element as? ImageDownloader {
                    downloader.clearSubscribers()
                }
            }
            let replaced = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            if  replaced != "" {
                delegate?.dataManager().search(self, query: replaced, searchIn: searchManagers) // searchManager might be set during a segue. Otherwise it defaults to all searchManagers, defined in the TumDataManager
            } else {
                elements = []
                tableView.reloadData()
            }
        }
        return true
    }
    
}

extension SearchViewController {
    
    override func viewDidLoad() {
        searchTextField.becomeFirstResponder()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = 102
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            mvc.room = currentElement
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = currentElement
        }
        if let mvc = segue.destination as? LectureDetailsTableViewController {
            mvc.lecture = currentElement
        }
    }
    
}

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentElement = elements[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: elements[indexPath.row].getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(elements[indexPath.row])
        return cell
    }
    
}
