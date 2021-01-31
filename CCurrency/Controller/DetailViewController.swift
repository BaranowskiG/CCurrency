import UIKit


class DetailViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Details"
    }
}
