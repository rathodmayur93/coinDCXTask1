//
//  MarketTableViewCell.swift
//  CoinDCX
//
//  Created by ds-mayur on 27/8/2020.
//

import UIKit
import SDWebImageSVGKitPlugin

class MarketTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var currencyLogo: UIImageView!
    
    @IBOutlet weak var coinPairLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var percentageView: UIView!
    
    //MARK:- Lifecycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setting up the UI
        setUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- UI Functions
    
    // Setting up the UI
    private func setUI(){
        
        //Make selection style of the tableView row as none
        self.selectionStyle = .none
        
        //Make the logo of the currency circular
        makeLogoCircular()
        
        //Make the percentage view rouned rectangle
        makeRoundedView()
    }
    
    //Make the logo of the currency circular
    private func makeLogoCircular(){
        currencyLogo.layer.cornerRadius = currencyLogo.frame.width / 2
        currencyLogo.layer.masksToBounds = true
    }
    
    //Make percentage view corners rounded
    private func makeRoundedView(){
        self.percentageView.layer.cornerRadius = 5.0
        self.percentageView.layer.masksToBounds = true
    }
    
    //MARK:- Feeding Data In TableView
    
    public func setupCell(at index : Int, presenter : ViewControllerPresener){
        
        //Fetching the coin information from the the viewController presenter
        let (baseCurrencyShort, targetCurrencyShort, coinName, dcxName, coinImageUrl) = presenter.getCoinMarketInfo(at: index)
        let (lastPrice, change) = presenter.getLastPriceAndPercentage(coinDCXName: dcxName)
        
        //Converting the change intot he NSString so that we can access floatValue property
        let percentageFloat = (change as NSString).floatValue
        let uptoTwoDecimalPercentage = String(format: "%.2f", percentageFloat)
        
        //Setting up the visible field's values
        settingUpVisibleInfo(baseCurrencyShort: baseCurrencyShort,
                             targetCurrencyShort: targetCurrencyShort,
                             coinName: coinName,
                             lastPrice: lastPrice,
                             percentage: uptoTwoDecimalPercentage,
                             imageUrl: coinImageUrl)
        
        //Setting up the overlayView
        var percetageOverlayAlpha = presenter.fetchAlphaValue(percentage: abs(percentageFloat))
        setupOverlayView(percentage: percentageFloat, alphaValue: &percetageOverlayAlpha)
        
    }
    
    //Setting up the visible field's values
    private func settingUpVisibleInfo(baseCurrencyShort short : String,
                                      targetCurrencyShort target : String,
                                      coinName name : String,
                                      lastPrice price : String,
                                      percentage value: String,
                                      imageUrl url : String){
        
        //Setting up the UIs visible element
        coinPairLabel.attributedText = NSMutableAttributedString()
                                       .bold(short)
                                       .normal("/"+target)
        coinNameLabel.text = name
//        coinValueLabel.attributedText = NSMutableAttributedString()
//                                         .bold("Last Price: ")
//                                        .normal(price)
        coinValueLabel.text = "Last Price: " + price
        percentageLabel.text = value + "%"
        
        //Loading the currency logo
        loadCoinImage(url: url)
    }
    
    
    //Load the coin image
    private func loadCoinImage(url : String){
        //Load coin logo
        currencyLogo.loadSVG(url: url)
    }
    
    //Setting up the Percentage change view background color
    private func setupOverlayView(percentage value : Float, alphaValue : inout Float){
        
        //Ternary conditional opertator to set the color of the percentage background view
        percentageView.backgroundColor = value <= 0 ? (UIColor(named: "loss")?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray) : UIColor(named: "gain")?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray
    }
    
}
