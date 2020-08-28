//
//  MarketTableViewDelegate.swift
//  CoinDCX
//
//  Created by ds-mayur on 27/8/2020.
//

import UIKit

class MarketTableViewDelegate : NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
