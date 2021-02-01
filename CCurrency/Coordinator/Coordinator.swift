import UIKit


enum Event {
    case openDetailView
}

protocol Coordinator {
    var navigationController: UINavigationController? {get set}
    func start()
    func eventOccurred(with type: Event)
}
