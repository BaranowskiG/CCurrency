import UIKit


class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?

    func start() {
        let appVC = AppViewController()
        appVC.coordinator = self
        navigationController?.setViewControllers([appVC], animated: false)
    }
    
    func eventOccurred(with type: Event) {
        switch type {
        case .openDetailView:
            let detailVC = DetailViewController()
            detailVC.coordinator = self
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
