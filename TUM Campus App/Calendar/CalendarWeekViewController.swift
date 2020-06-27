import UIKit
import CalendarKit
import Alamofire
import CoreData
import XMLCoder

final class CalendarWeekViewController: DayViewController {
    typealias ImporterType = Importer<CalendarEvent,APIResponse<CalendarAPIResponse,TUMOnlineAPIError>,XMLDecoder>

    private static let endpoint: URLRequestConvertible = TUMOnlineAPI.calendar
    private static let sortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.startDate, ascending: true)
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: sortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }

    private func setupUI() {
        title = "Calendar".localized
        edgesForExtendedLayout = UIRectEdge.all

        dayView.backgroundColor = .systemBackground
        dayView.autoScrollToFirstEvent = true

        navigationController?.navigationBar.prefersLargeTitles = true

        var style = CalendarStyle()
        style.header.backgroundColor = .systemBackground
        style.header.daySelector.todayActiveBackgroundColor = .tumBlue
        style.header.daySelector.todayInactiveTextColor = .tumBlue
        style.timeline.backgroundColor = .systemBackground
        style.timeline.timeIndicator.color = .tumBlue
        dayView.updateStyle(style)
    }

    @objc private func fetch(animated: Bool = true) {
        importer.performFetch(success: { [weak self] in
            self?.reload()
        }, error: { [weak self] error in
            switch error {
            case is TUMOnlineAPIError:
                guard let context = self?.importer.context else { break }
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
                _ = try? context.execute(deleteRequest) as? NSBatchDeleteResult
                self?.reload()
            default: break
            }
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()
        dayView.reloadData()
    }

    // MARK: - EventDataSource

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let events = importer.fetchedResultsController.fetchedObjects ?? []
        return events.compactMap { CalendarEventViewModel(event: $0) }
    }

    // MARK: - Actions

    @IBAction func showToday(_ sender: Any) {
        dayView.state?.move(to: Date())
    }

}
