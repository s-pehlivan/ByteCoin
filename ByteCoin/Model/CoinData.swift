//
//  CoinData.swift
//  ByteCoin
//
//  Created by Sora on 7.07.2022.
//

import Foundation

struct CoinData: Decodable {
    let asset_id_quote: String
    let rate: Double
}
