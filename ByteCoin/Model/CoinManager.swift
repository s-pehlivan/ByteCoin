//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Sora on 7.07.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func getCurrentPrice(_ coinManager: CoinManager, coin: CoinModal)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let apiKey = Keys().apiKey // Insert Your OpenWeather API Key.
    
    var selectedCurrency: String = "USD"
        
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var coinDelegate: CoinManagerDelegate?
    
    mutating func getSelectedCurrency(_ currency: String) {
        selectedCurrency = currency
    }
    
    func fetchUrl() {
        let urlString = "\(baseURL)/\(selectedCurrency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            print(urlString)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.coinDelegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.coinDelegate?.getCurrentPrice(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModal? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let currentRate = decodedData.rate
            let targetCurrency = decodedData.asset_id_quote
            
            let coin = CoinModal(currentRate: currentRate, targetCurrency: targetCurrency)
            
            return coin
        }catch {
            self.coinDelegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
