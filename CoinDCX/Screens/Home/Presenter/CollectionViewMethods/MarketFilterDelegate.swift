//
//  MarketFilterDelegate.swift
//  CoinDCX
//
//  Created by ds-mayur on 28/8/2020.
//

import UIKit

//Market Filter Delegate Methods
class MarketFilterDelegate : NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //MARK:- Delegate Flow Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 40)
    }
    
    //MARK:- Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Seleted Filter \(indexPath.item)")
    }
}
