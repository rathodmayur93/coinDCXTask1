//
//  TickerDetailModel.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

// MARK: - TickerModelElement
struct TickerModel: Codable, Hashable {
    let market: String
    let change24_Hour, high, low, volume: String?
    let lastPrice: String?
    let bid, ask: Ask
    let timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case market
        case change24_Hour = "change_24_hour"
        case high, low, volume
        case lastPrice = "last_price"
        case bid, ask, timestamp
    }
}

enum Ask: Codable, Hashable {
    case double(Double)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(Ask.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Ask"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

extension Array where Element == TickerModel{
    
    // Filter the array based on the BASE CURRENCY SHORT NAME
    func sortAscending(baseCurrencyShortName : String) -> [TickerModel]{
        
        return self.sorted { (obj1, obj2) -> Bool in
            return (Float(obj1.change24_Hour?.lowercased() ?? "") ?? 0.0) > (Float(obj2.change24_Hour?.lowercased() ?? "") ?? 0.0)
        }
    }
}
