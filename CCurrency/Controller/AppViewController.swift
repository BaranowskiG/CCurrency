import UIKit


class AppViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    var appViewModel = AppViewModel()
    private let tableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
    
    var response = [String:Double]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
        appViewModel.fetchLatestJSON { [weak self] result in
            switch result {
            case .success(let exchangeRate):
                self?.response = exchangeRate.rates
                self?.response.removeValue(forKey: "PLN")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func setupView() {
        title = "1 PLN"
        view.backgroundColor = .systemBackground
        coordinator?.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(tableView)
    }
}


extension AppViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let value = String(format:"%.2f" ,Array(response)[indexPath.row].value)
        let key = Array(response)[indexPath.row].key
        cell.textLabel?.text = "\(key)"
        cell.accessoryType = .disclosureIndicator
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = value
        label.textAlignment = .right
        cell.accessoryView = label

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.eventOccurred(with: .openDetailView)
    }
}
