//
//  FilterCollectionViewCell.swift
//  CoinDCX
//
//  Created by ds-mayur on 28/8/2020.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var selectedFilterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setting up the UI element
        setUI()
    }
    
    //Setting up the UI element
    private func setUI(){
        selectedFilterView.layer.cornerRadius = 5;
        
        self.contentView.layer.cornerRadius = 10.0
    }
    
    //Setting up the cell
    public func setupCell(at index : Int, presenter : ViewControllerPresener){
        
        //Fetching the filter list
        let list = presenter.filterList
        
        //Setting up the selected filter views
        selectedFilterView.isHidden = true
        selectedFilterView.backgroundColor = UIColor(named: Colors.brand.colorName())
        
        if(list?[index].isFilterSelected ?? false){
            setupFilterBackground()
        }else{
            removeFilterBackground()
        }
        
        //Setting up the filter name
        filterLabel.text = list?[index].filterName ?? ""
    }
    
    //Setting up the selected filter background
    private func setupFilterBackground(){
        self.contentView.backgroundColor = UIColor(named: Colors.brand.colorName()) ?? UIColor.gray
        filterLabel.textColor = UIColor.white
    }
    
    //Remove the selected filter background color and text color
    private func removeFilterBackground(){
        self.contentView.backgroundColor = UIColor(named: Colors.background.colorName()) ?? UIColor.white
        filterLabel.textColor = UIColor(named: Colors.textColor.colorName()) ?? UIColor.gray
    }
}
