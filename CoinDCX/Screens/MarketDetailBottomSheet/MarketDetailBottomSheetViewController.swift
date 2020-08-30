//
//  MarketDetailBottomSheetViewController.swift
//  CoinDCX
//
//  Created by ds-mayur on 29/8/2020.
//

import UIKit

class MarketDetailBottomSheetViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var currencyLogo: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    
    @IBOutlet weak var lastTradedPriceLabel : UILabel!
    @IBOutlet weak var percentageView       : UIView!
    @IBOutlet weak var percentageLabel      : UILabel!
    
    @IBOutlet weak var highLabel            : UILabel!
    @IBOutlet weak var lowLabel             : UILabel!
    
    //MARK:- Vaiables
    public var presenter : ViewControllerPresener?
    public var index : Int?
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI
        setUI()
    }
    
    //MARK:- UI Function
    
    //Setting up the UI
    private func setUI(){
        
        //Unwrapping the presenter and index values
        guard let vcPresenter = presenter, let atIndex = index else { return }
        
        //Setting up teh header information
        setupHeaderInfo(presenter: vcPresenter, at: atIndex)
        
        //Setting up the price information
        setupPricesInfo(presenter: vcPresenter, at: atIndex)
    }
    
    //MARK: Header Information
    //Setting up the header section information
    private func setupHeaderInfo(presenter vcPresenter : ViewControllerPresener, at atIndex : Int){
        
        //Loading the currency logo
        currencyLogo.loadSVG(url: Endpoints.imageUrl(coinName: vcPresenter.marketListModel?[atIndex].targetCurrencyShortName ?? "").path())
        
        //Setting the currency name
        currencyName.attributedText  = NSMutableAttributedString()
            .bold(vcPresenter.marketListModel?[atIndex].targetCurrencyName ?? "")
            .normal(" (" + (vcPresenter.marketListModel?[atIndex].targetCurrencyShortName ?? "") + ")")
    }
    
    //MARK: Prices Information
    //Setting up the last trade, 24 hour high & 24 hour low price
    private func setupPricesInfo(presenter vcPresenter : ViewControllerPresener, at atIndex : Int){
        
        //Setting the last trade price of the coin
        let (lastPrice, percentage) = vcPresenter.getLastPriceAndPercentage(coinDCXName: vcPresenter.marketListModel?[atIndex].coindcxName ?? "")
        
        //Setting up the last traded price
        lastTradedPriceLabel.text = lastPrice + " " + (vcPresenter.marketListModel?[atIndex].baseCurrencyShortName ?? "")
        
        // Fetching & Setting the 24 hour high and low trade perice
        let (high, low) = vcPresenter.getHighAndLowPrice(coinDCXName: vcPresenter.marketListModel?[atIndex].coindcxName ?? "")
        lowLabel.text   = "₹ " + low
        highLabel.text  = "₹ " + high
        
        //Setting up the percentage info
        setupPercentageInfo(presenter: vcPresenter, percentageValue: percentage)
    }
    
    //MARK: Percentage Setup
    //Setup percentage info
    private func setupPercentageInfo(presenter vcPresenter : ViewControllerPresener, percentageValue percentage : String){
        
        //Percentage gain or loss
        let percentageFloat = (percentage as NSString).floatValue
        let uptoTwoDecimalPercentage = String(format: "%.2f", percentageFloat)
        percentageLabel.text = uptoTwoDecimalPercentage + "%"
        
        //Fetching the alpha percentage value
        var percetageOverlayAlpha = vcPresenter.fetchAlphaValue(percentage: abs(percentageFloat))
        
        //Setting up the percentageView
        setupPercentageView(percentage: percentageFloat, alphaValue: &percetageOverlayAlpha)
    }
    
    //Setting up the percentage view
    private func setupPercentageView(percentage value : Float, alphaValue : inout Float){
        
        //Setting up the rounded corner rectangle
        percentageView.layer.cornerRadius = 10
        percentageView.layer.masksToBounds = true
        
        //Ternary conditional opertator to set the color of the percentage background view
        percentageView.backgroundColor = value <= 0 ?
            (UIColor(named: Colors.loss.colorName())?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray) :
            UIColor(named: Colors.gain.colorName())?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray
    }
}
