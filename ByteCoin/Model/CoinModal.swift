//
//  CoinModal.swift
//  ByteCoin
//
//  Created by Sora on 7.07.2022.
//

import Foundation

struct CoinModal {
    let currentRate: Double
    let targetCurrency: String
    
    var currentRateString : String {
        return String(currentRate)
    }
}
