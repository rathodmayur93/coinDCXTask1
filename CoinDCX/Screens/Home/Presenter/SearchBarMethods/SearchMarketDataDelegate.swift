//
//  SearchMarketDataDelegate.swift
//  CoinDCX
//
//  Created by ds-mayur on 29/8/2020.
//

import UIKit

class SearchMarketDataDelegate : MarketListData, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let presenter = viewControllerPresenter{
            presenter.filterSearchedData(searchedText: searchText)
        }
    }
}
