import UIKit


struct Networking {
    
    let url = "https://api.exchangeratesapi.io/"
    
    func fetchLatestJSON(completion: @escaping (Result<ExchangeRate, Error>) -> ()) {
        guard let endpoint = URL(string: url+"latest?base=PLN") else {return}
        
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
