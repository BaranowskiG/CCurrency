import UIKit

class AppViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.setTitle("tap me!", for: .normal)
        button.addTarget(self, action: #selector(openDetailView), for: .touchUpInside)
        
    }
    
    @objc func openDetailView() {
        coordinator?.eventOccurred(with: .openDetailView)
    }
    
}

