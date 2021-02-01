import UIKit


class AppViewController: UIViewController {
    var coordinator: AppCoordinator?
    var appViewModel = AppViewModel()
    private let appTableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
    
    var response = [String:Double]() {
        didSet {
            DispatchQueue.main.async {
                self.appTableView.reloadData()
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
        appTableView.dataSource = self
        appTableView.delegate = self
        appTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.appTableViewCell)
        appTableView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width, height: view.frame.height)
        view.addSubview(appTableView)
    }
}


extension AppViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.appTableViewCell, for: indexPath)
        let sortedResponse = Array(response).sorted(by: <)
        let value = String(format: "%.2f", sortedResponse[indexPath.row].value)
        let key = sortedResponse[indexPath.row].key
        cell.textLabel?.text = "\(key)"
        cell.accessoryType = .disclosureIndicator
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = value
        label.textAlignment = .right
        cell.accessoryView = label

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.tappedCurrencyName = "\(Array(response).sorted(by: <)[indexPath.row].key)"
        coordinator?.eventOccurred(with: .openDetailView)
    }
}
