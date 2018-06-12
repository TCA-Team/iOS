//
//  SearchResultsController.swift
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
import Sweeft


class SearchResultsController: UITableViewController {
    
    weak var delegate: DetailViewDelegate?
    weak var navCon: UINavigationController?
    var promise: Response<[SearchResults]>?
    
    var currentElement: DataElement?
    public var elements: [SearchResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
            self.tableView.backgroundView = blurEffectView

        } else {
            self.view.backgroundColor = .black
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !elements[section].results.isEmpty else {
            return nil
        }
        return elements[section].key.description
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentElement = elements[indexPath.section].results[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentElement!.getCellIdentifier() {
        case "person":
            let storyboard = UIStoryboard(name: "PersonDetail", bundle: nil)
            if let personDetailTableViewController =
                storyboard.instantiateInitialViewController() as? PersonDetailTableViewController {
                personDetailTableViewController.user = currentElement
                personDetailTableViewController.delegate = self
                navCon?.pushViewController(personDetailTableViewController, animated: true)
            }
        case "lecture":
            let storyboard = UIStoryboard(name: "LectureDetail", bundle: nil)
            if let lectureDetailViewController =
                storyboard.instantiateInitialViewController() as? LectureDetailsTableViewController {
                lectureDetailViewController.lecture = currentElement
                lectureDetailViewController.delegate = self
                navCon?.pushViewController(lectureDetailViewController, animated: true)
            }
        case "room":
            let storyboard = UIStoryboard(name: "RoomFinder", bundle: nil)
            if let roomFinderView =
                storyboard.instantiateInitialViewController() as? RoomFinderViewController {
                roomFinderView.room = currentElement
                roomFinderView.delegate = self
                navCon?.pushViewController(roomFinderView, animated: true)
            }
        case "sexy":
            (currentElement as? SexyEntry)?.open(sender: navCon)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements[section].results.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.section].results[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: element.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        
        cell.setElement(element)
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension SearchResultsController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SearchResultsController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
    }
    
}

extension SearchResultsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        promise?.cancel()
        if let query = searchController.searchBar.text {
            promise = delegate?.dataManager()?.search(query: query).onSuccess(in: .main) { elements in
                self.elements = elements
            }
        }
    }
    
}
