//
//  Colors.swift
//  CoinDCX
//
//  Created by ds-mayur on 28/8/2020.
//

enum Colors{
    case background
    case brand
    case gain
    case loss
    case textColor
    
    func colorName() -> String{
        switch self {
        case .background:
            return "background"
        case .brand:
            return "brand"
        case .gain:
            return "gain"
        case .loss:
            return "loss"
        case .textColor:
            return "textColor"
        }
    }
}
