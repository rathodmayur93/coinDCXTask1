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
        self.contentView.layer.cornerRadius = 10.0
    }
    
    //Setting up the cell
    public func setupCell(at index : Int, presenter : ViewControllerPresener){
        
        //Setting the filter label text as blank
        filterLabel.text = ""
        
        //Setting up the selected filter views
        selectedFilterView.isHidden = true
        
        changeFilter(at: index, presenter: presenter)
    }
    
    //Setting up the logic to make selected filter background different from other filters
    public func changeFilter(at index : Int, presenter : ViewControllerPresener){
        
        //Fetching the filter list
        guard let list = presenter.filterList else { return }
        
        /*
            - If condition will check whether fitlter is selected or not
            - If filter is selected then will set background colors as selected
            - Else will remove the background color of the filter
        */
        
        if(list[index].isFilterSelected){
            // Chnage background color of the cell as seleted
            setupFilterBackground()
        }else{
            // Change the background color of the cell as unselected
            removeFilterBackground()
        }
        
        //Setting up the filter name
        filterLabel.text = list[index].filterName
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
