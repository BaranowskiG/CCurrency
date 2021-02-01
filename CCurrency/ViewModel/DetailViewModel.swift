import UIKit


struct DetailViewModel {
    var currencyName: String?
        
    func fetchLatestJSON(completion: @escaping (Result<ExchangeHistory, Error>) -> ()) {
        guard let endpoint = URL(string: getURL()) else {return}
        
        URLSession.shared.dataTask(with: endpoint) { (data, ress, err) in
            guard let data = data else {return}
            
            do {
                let exchangeHistory = try JSONDecoder().decode(ExchangeHistory.self, from: data)
                completion(.success(exchangeHistory))
                
            } catch let jsonErr {
                completion(.failure(jsonErr))
            }
            
        }.resume()
    }
    
    private func getURL() -> String {
        let startDate = "2019-10-02"
        let endDate = "2019-10-10" //Date()
        let symbol = currencyName ?? "PLN"
        return "\(Constant.url)history?start_at=\(startDate)&end_at=\(endDate)&symbols=\(symbol)&base=PLN"
    }
}
