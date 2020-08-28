//
//  TickerDetailModel.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

// MARK: - TickerModelElement
struct TickerModel: Codable {
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

enum Ask: Codable {
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
