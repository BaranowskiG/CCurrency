import UIKit


class DetailViewController: UIViewController {
    var coordinator: AppCoordinator?
    var currencyName: String?
    var detailViewModel = DetailViewModel()
    private let detailTableView = UITableView(frame: UIScreen.main.bounds, style: .insetGrouped)
    var response = [String: [String: Double]]() {
        didSet {
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "\(currencyName!)"
        setupTableView()
        detailViewModel.currencyName = currencyName
        detailViewModel.fetchLatestJSON { [weak self] (result) in
            switch result {
            case .success(let exchangeHistory):
                self?.response = exchangeHistory.rates
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func setupTableView() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.detailTableViewCell)
        detailTableView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width, height: view.frame.height)
        view.addSubview(detailTableView)
    }
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.detailTableViewCell, for: indexPath)
        let sortedResponse = Array(response)
        let key = sortedResponse[indexPath.row].key
        let value = sortedResponse[indexPath.row].value["\(currencyName!)"]
        cell.textLabel?.text = "\(key)"
        cell.accessoryType = .disclosureIndicator
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = String(format: "%.4f", value!)
        label.textAlignment = .right
        cell.accessoryView = label

        return cell
    }
}
