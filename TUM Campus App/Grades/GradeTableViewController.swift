//
//  GradeTableViewController.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/21/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import XMLParsing
import Charts

final class GradeTableViewController: UITableViewController, EntityTableViewControllerProtocol {
    typealias ResponseType = APIResponse<GradesAPIResponse, TUMOnlineAPIError>
    typealias ImporterType = Importer<Grade,ResponseType,XMLDecoder>

    @IBOutlet private weak var barChartView: BarChartView!
    private let endpoint: URLRequestConvertible = TUMOnlineAPI.personalGrades
    private let sortDescriptor = NSSortDescriptor(keyPath: \Grade.semester, ascending: false)
    lazy var importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(DateFormatter.yyyyMMdd))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        importer.fetchedResultsController.delegate = self
        title = "Grades".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }

    @objc private func fetch(animated: Bool = true) {
        if animated {
            tableView.refreshControl?.beginRefreshing()
        }
        importer.performFetch(success: { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.reloadData()
            self?.setupHeaderView()
        }, error: { [weak self] error in
            self?.tableView.refreshControl?.endRefreshing()
            guard error is TUMOnlineAPIError else { return }
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: Grade.fetchRequest())
            _ = try? self?.importer.context.execute(deleteRequest)
            try? self?.importer.fetchedResultsController.performFetch()
            self?.tableView.reloadData()
            self?.setupHeaderView()
            self?.setBackgroundLabel(with: error.localizedDescription)
        })
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }

    private func setupHeaderView() {
        guard let grades = importer.fetchedResultsController.fetchedObjects else { return }
        let gradeValues = grades.compactMap { Decimal(string: $0.grade?.replacingOccurrences(of: ",", with: ".") ?? "") }
        let gradeMap = gradeValues.reduce(into: [:]) { $0[$1] = ($0[$1] ?? 0) + 1 }.sorted { $0.key < $1.key }
        let gradeStrings: [String] = gradeMap.compactMap {
            let formatter = NumberFormatter()
            formatter.alwaysShowsDecimalSeparator = true
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter.string(from: $0.key as NSDecimalNumber)
        }
        var dataEntries: [BarChartDataEntry] = []
        var colors: [UIColor] = []

        for grade in gradeMap.enumerated() {
            let entry = BarChartDataEntry(x: Double(grade.offset), y: Double(grade.element.value))
            dataEntries.append(entry)
            switch grade.element.key {
            case 1.0..<2.0:
                colors.append(.systemGreen)
            case 2.0..<3.0:
                colors.append(.systemYellow)
            case 3.0...4.0:
                colors.append(.systemOrange)
            case 4.3...5.0:
                colors.append(.systemRed)
            default:
                colors.append(.systemGray)
            }
        }

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0

        let dataSet = BarChartDataSet(entries: dataEntries)
        dataSet.colors = colors
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        let chartData = BarChartData(dataSet: dataSet)

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: gradeStrings)

        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularity = 1.0

        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false

        let legend = barChartView.legend
        legend.enabled = false

        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutSine)
        barChartView.drawGridBackgroundEnabled = false
        barChartView.fitBars = true
        barChartView.isUserInteractionEnabled = false
        barChartView.drawValueAboveBarEnabled = true
    }



    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = importer.fetchedResultsController.sections?.count

        switch numberOfSections {
        case let .some(count) where count > 0:
            tableView.backgroundView = nil
        case let .some(count) where count == 0:
            setBackgroundLabel(with: "No Grades".localized)
        default:
            break
        }

        return numberOfSections ?? 0
    }
       
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return importer.fetchedResultsController.sections?[section].name
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importer.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GradeCell.reuseIdentifier, for: indexPath) as! GradeCell
        guard let grade = importer.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.configure(grade: grade)
        
        return cell
    }

    // MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

}
