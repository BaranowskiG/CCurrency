import UIKit


struct ExchangeRate: Codable {
    var base: String
    var rates: [String: Double]
}
