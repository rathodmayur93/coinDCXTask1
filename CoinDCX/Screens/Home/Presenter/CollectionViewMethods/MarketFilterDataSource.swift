//
//  MarketFilterDataSource.swift
//  CoinDCX
//
//  Created by ds-mayur on 28/8/2020.
//

import UIKit

// Market Filter DataSource Methods
class MarketFilterDataSource : MarketListData, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllerPresenter?.filterList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.filterCell, for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let presenter = viewControllerPresenter{
            cell.setupCell(at: indexPath.item, presenter: presenter)
        }
        
        return cell
    }
}
