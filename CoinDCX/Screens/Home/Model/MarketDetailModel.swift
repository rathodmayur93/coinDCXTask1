//
//  MarketDetailModel.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

// MARK: - MarketDetailModelElement
struct MarketDetailModel: Codable, Hashable {
    let coindcxName: String?
    let baseCurrencyShortName: String?
    let targetCurrencyShortName, targetCurrencyName: String?
    let baseCurrencyName: String?
    let minQuantity, maxQuantity, minPrice, maxPrice: Double?
    let minNotional: Double?
    let baseCurrencyPrecision, targetCurrencyPrecision: Int?
    let step: Double?
    let orderTypes: [String]?
    let symbol: String?
    let ecode: String?
    let maxLeverage, maxLeverageShort: Int?
    let pair: String?
    let status: Status?
    var ticker : TickerModel?

    enum CodingKeys: String, CodingKey {
        case coindcxName = "coindcx_name"
        case baseCurrencyShortName = "base_currency_short_name"
        case targetCurrencyShortName = "target_currency_short_name"
        case targetCurrencyName = "target_currency_name"
        case baseCurrencyName = "base_currency_name"
        case minQuantity = "min_quantity"
        case maxQuantity = "max_quantity"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case minNotional = "min_notional"
        case baseCurrencyPrecision = "base_currency_precision"
        case targetCurrencyPrecision = "target_currency_precision"
        case step
        case orderTypes = "order_types"
        case symbol, ecode
        case maxLeverage = "max_leverage"
        case maxLeverageShort = "max_leverage_short"
        case pair, status
    }
}

// BaseCurrencyName
enum BaseCurrencyName: String, Codable {
    case binanceCoin = "Binance Coin"
    case bitcoin = "Bitcoin"
    case dai = "Dai"
    case ethereum = "Ethereum"
    case indianRupee = "Indian Rupee"
    case ripple = "Ripple"
    case tether = "Tether"
    case trueUSD = "True USD"
    case usdCoin = "USD Coin"
}

// BaseCurrencyShortName
enum BaseCurrencyShortName: String, Codable {
    case bnb = "BNB"
    case btc = "BTC"
    case dai = "DAI"
    case eth = "ETH"
    case inr = "INR"
    case tusd = "TUSD"
    case usdc = "USDC"
    case usdt = "USDT"
    case xrp = "XRP"
}

// Ecode
enum Ecode: String, Codable {
    case b = "B"
    case h = "H"
    case hb = "HB"
    case i = "I"
}

// OrderType

enum OrderType: String, Codable {
    case limitOrder = "limit_order"
    case marketOrder = "market_order"
    case stopLimit = "stop_limit"
    case takeProfit = "take_profit"
}

// Status
enum Status: String, Codable {
    case active = "active"
}


extension Array where Element == MarketDetailModel {
    
    // Filter the array based on the BASE CURRENCY SHORT NAME
    func baseCurrencyFilter(baseCurrencyShortName : String) -> [MarketDetailModel]{
        
        let filterList = self.filter{ $0.baseCurrencyShortName == baseCurrencyShortName }
        return filterList
    }
    
    // Sort the array in ascending order based on the target currency alphabatical order
    func sortAscending() -> [MarketDetailModel]{
        return self.sorted { (obj1, obj2) -> Bool in
            return (obj1.targetCurrencyName?.lowercased() ?? "") < (obj2.targetCurrencyName?.lowercased() ?? "")
        }
    }
    
    // Sort the array in decending order based on the target currency alphabatical order
    func sortDecending() -> [MarketDetailModel]{
        return self.sorted { (obj1, obj2) -> Bool in
            return (obj1.targetCurrencyName?.lowercased() ?? "") > (obj2.targetCurrencyName?.lowercased() ?? "")
        }
    }
    
    // Sort the array in ascending order based on the 24 hour change in percentage
    func sortChangeAscending() -> [MarketDetailModel]{
        return self.sorted { (obj1, obj2) -> Bool in
            return ((Double(obj1.ticker?.change24_Hour ?? "") ?? 0.0) < (Double(obj2.ticker?.change24_Hour ?? "") ?? 0.0))
        }
    }
    
    // Sort the array in decending order based on the 24 hour change in percentage
    func sortChangeDecending() -> [MarketDetailModel]{
        return self.sorted { (obj1, obj2) -> Bool in
            return ((Double(obj1.ticker?.change24_Hour ?? "") ?? 0.0) > (Double(obj2.ticker?.change24_Hour ?? "") ?? 0.0))
        }
    }
    
    //Filter the array based on the searched text
    func searchedhData(searchText text : String) -> [MarketDetailModel] {
        return self.filter { (marketData) -> Bool in
            return (marketData.targetCurrencyName?.contains(text) ?? false)
        }
    }
    
    
}
