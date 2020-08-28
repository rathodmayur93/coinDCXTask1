//
//  MarketListDataSource.swift
//  CoinDCX
//
//  Created by ds-mayur on 27/8/2020.
//

import UIKit

// Market List Data Parent Class
class MarketListData : NSObject{
    var viewControllerPresenter : ViewControllerPresener?
}

// TableView DataSource Methods
class MarketListDataSource : MarketListData, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Market List Count \(viewControllerPresenter?.marketListModel?.count ?? 0)")
        return viewControllerPresenter?.marketListModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.marketDetailCell) as? MarketTableViewCell,
              let presenter = viewControllerPresenter
        else {
            return UITableViewCell()
        }
        
        cell.setupCell(at: indexPath.row, presenter: presenter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.marketDetailCell) as? MarketTableViewCell,
                  let presenter = viewControllerPresenter
            else { return }
            
            cell.setupCell(at: indexPath.row, presenter: presenter)
        }
    }
}
