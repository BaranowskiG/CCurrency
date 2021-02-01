import UIKit

struct AppViewModel {
    
    let endpoint = Constant.url+"latest?base=PLN"
        
    func fetchLatestJSON(completion: @escaping (Result<ExchangeRate, Error>) -> ()) {
        guard let endpoint = URL(string: endpoint) else {return}
        
        URLSession.shared.dataTask(with: endpoint) { (data, ress, err) in
            guard let data = data else {return}
            
            do {
                let exchangeRate = try JSONDecoder().decode(ExchangeRate.self, from: data)
                completion(.success(exchangeRate))
                
            } catch let jsonErr {
                completion(.failure(jsonErr))
            }
            
        }.resume()
    }
    
    func getHistory(of: String) {
        
    }

}
