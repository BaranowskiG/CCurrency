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
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDay = calendar.component(.weekday, from: now)
        let daysDeducted = currentDay == 2 ? -13 : -14
        let twoWeeksAgo = calendar.date(byAdding: .day, value: daysDeducted, to: now)
        let dateComponent = DateComponents(calendar: calendar, weekday: 3)
        let start = calendar.nextDate(after: twoWeeksAgo!, matching: dateComponent, matchingPolicy: .nextTimePreservingSmallerComponents)
        
        let startDate = dateFormatter.string(from: start!)
        let endDate = dateFormatter.string(from: now)
        let symbol = currencyName ?? "PLN"
        return "\(Constant.url)history?start_at=\(startDate)&end_at=\(endDate)&symbols=\(symbol)&base=PLN"
    }
}
