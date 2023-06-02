//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Илья Мишин on 02.06.2023.
//

import SwiftUI

enum ConversionError: Error {
    case invalidAmount
    case apiFailure
}

struct CurrencyResponse: Codable {
    let rates: [String: Double]
}

class ViewModel: ObservableObject {
    @Published var amount: Double = 0.0
    @Published var selectedCurrencyFrom = 0
    @Published var selectedCurrencyTo = 1
    @Published var conversionResult: Double = 0.0
    @Published var favoritePairs: [String] = []
    @Published var currencies: [String] = []
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    private let favoritePairsKey = "favoritePairs"
    
    init() {
        fetchCurrencies()
    }

    func saveFavoritePairs() {
        UserDefaults.standard.set(favoritePairs, forKey: favoritePairsKey)
    }

    func loadFavoritePairs() {
        if let savedPairs = UserDefaults.standard.array(forKey: favoritePairsKey) as? [String] {
            favoritePairs = savedPairs
        }
    }

    func removeFavoritePair(at index: Int) {
        favoritePairs.remove(at: index)
        
        saveFavoritePairs()
        
        if index == selectedCurrencyFrom || index == selectedCurrencyTo {
            selectedCurrencyFrom = 0
            selectedCurrencyTo = 1
        }
    }

    func addFavoritePair() {
        let fromCurrency = currencies[selectedCurrencyFrom]
        let toCurrency = currencies[selectedCurrencyTo]
        let pair = "\(fromCurrency) to \(toCurrency)"

        if !favoritePairs.contains(pair) {
            favoritePairs.append(pair)
        }
    }

    func fetchCurrencies() {
        guard let url = URL(string: "https://open.exchangerate-api.com/v6/latest") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let response = try? JSONDecoder().decode(CurrencyResponse.self, from: data) {
                    let rates = response.rates
                    for rateKey in rates.keys.sorted() {
                        DispatchQueue.main.async {
                            self.currencies.append(rateKey)
                        }
                    }
                }
            }
        }.resume()
    }

    func convertCurrency() {
        guard amount > 0 else {
            showInvalidAmountAlert()
            return
        }
        let fromCurrency = currencies[selectedCurrencyFrom]
        let toCurrency = currencies[selectedCurrencyTo]
        
        guard let url = URL(string: "https://open.exchangerate-api.com/v6/latest") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.showConversionErrorAlert(error: error!)
                }
                return
            }
            if let data = data {
                if let response = try? JSONDecoder().decode(CurrencyResponse.self, from: data) {
                    let rates = response.rates
                    if let conversionRate = rates[toCurrency] {
                        DispatchQueue.main.async {
                            self.conversionResult = self.amount * conversionRate
                        }
                    }
                }
            }
        }.resume()
    }
    
    func showConversionErrorAlert(error: Error) {
            alertTitle = "Error"
            alertMessage = "Failed to convert currency. \(error.localizedDescription)"
            showAlert = true
        }
        
    func showInvalidAmountAlert() {
            alertTitle = "Invalid Amount"
            alertMessage = "Please enter a valid amount."
            showAlert = true
        }
}
