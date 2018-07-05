//
//  RoomFinderViewController.swift
//  TUM Campus App
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

class RoomFinderViewController: UIViewController, DetailView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: DetailViewDelegate?
    var room: DataElement?
    
    var barItem: UIBarButtonItem?
    var maps = [Map]()
    var currentMap: Map? {
        didSet {
            refreshImage()
        }
    }
    
    var binding: ImageViewBinding?
    
    func refreshImage() {
        binding = currentMap?.image.bind(to: imageView, default: nil)
        title = currentMap?.description
        scrollView.zoomScale = 1.0
        scrollView.contentSize = imageView.bounds.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
}

extension RoomFinderViewController {
    
    func fetch(id: String) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        delegate?.dataManager()?
            .roomMapsManager
            .search(query: id)
            .onSuccess(in: .main) { maps in
                self.activityIndicator.stopAnimating()
                self.maps = maps.sorted { $0.scale < $1.scale }
                if !maps.isEmpty {
                    self.currentMap = self.maps.first
                }
                self.setUpPickerView()
            }
    }
    
}

extension RoomFinderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
        
        if let roomUnwrapped = room as? Room {
            fetch(id: roomUnwrapped.number)
        } else if let roomUnwrapped = room as? StudyRoom {
            fetch(id: roomUnwrapped.architectNumber)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
}

extension RoomFinderViewController: TUMPickerControllerDelegate {
    
    @objc func showMaps(_ send: UIBarButtonItem?) {
        let pickerView = TUMPickerController(elements: maps, selected: currentMap, delegate: self)
        pickerView.popoverPresentationController?.barButtonItem = send
        present(pickerView, animated: true)
    }
    
    func didSelect(element: Map) {
        currentMap = element
    }
    
}

extension RoomFinderViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

extension RoomFinderViewController {
    
    func setUpPickerView() {
        let barItem = UIBarButtonItem(image: UIImage(named: "expand"), style: .plain, target: self,
                                      action:  #selector(RoomFinderViewController.showMaps(_:)))
        navigationItem.rightBarButtonItem = barItem
    }
    
}
