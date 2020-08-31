//
//  Constants.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

enum Endpoints{
    
    case logoUrl
    case logoWhiteUrl
    case marketDetail
    case ticker
    case imageUrl(coinName : String)
    
    /// Return the value for each **ENUM CASE**
    public func path() -> String {
        
        switch self {
        case .logoUrl: return "https://coindcx.com/assets/new-home-page/Fold1_Logo.svg"
        case .logoWhiteUrl: return "https://coindcx.com/assets/new-home-page/CD_LogoWhite.svg"
        case .marketDetail: return Constants.baseUrl + "exchange/v1/markets_details"
        case .ticker: return Constants.baseUrl + "exchange/ticker"
        case .imageUrl(let coinName):
            return Constants.imageBaseUrl + coinName + ".svg"
        }
    }
}
