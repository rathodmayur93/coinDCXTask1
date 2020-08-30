//
//  MarketTableViewDelegate.swift
//  CoinDCX
//
//  Created by ds-mayur on 27/8/2020.
//

import UIKit

class MarketTableViewDelegate : MarketListData, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = viewControllerPresenter {
            presenter.didSelectTableViewRow(at: indexPath.row)
        }
    }
}
