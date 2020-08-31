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
        let (logo, targetCurrency, targetCurrecyShort, lastPrice, change, high, low, alpha) = vcPresenter.fetchBottomSheetInfo(at: atIndex)
        
        //Setting up teh header information
        setupHeaderInfo(logo: logo, targetCurrency: targetCurrency, targetCurrencyShort: targetCurrecyShort)
        
        //Setting up the price information
        setupPricesInfo(lastPrice: lastPrice, percentage: change, high: high, low: low, alphaValue: alpha)
    }
    
    //MARK: Header Information
    //Setting up the header section information
    private func setupHeaderInfo(logo : String, targetCurrency : String, targetCurrencyShort : String){
        
        //Loading the currency logo
        currencyLogo.loadSVG(url: logo)
        
        //Setting the currency name
        currencyName.attributedText  = NSMutableAttributedString()
            .bold(targetCurrency)
            .normal(" (" + (targetCurrencyShort) + ")")
    }
    
    //MARK: Prices Information
    //Setting up the last trade, 24 hour high & 24 hour low price
    private func setupPricesInfo(lastPrice : String, percentage : String, high : String, low : String, alphaValue : CGFloat){
        
        
        //Setting up the last traded price
        lastTradedPriceLabel.text = "₹ " + lastPrice
        
        // Fetching & Setting the 24 hour high and low trade perice
        lowLabel.text   = "₹ " + low
        highLabel.text  = "₹ " + high
        
        //Setting up the percentage info
        setupPercentageInfo(percentageValue: percentage, alphaValue: alphaValue)
    }
    
    //MARK: Percentage Setup
    //Setup percentage info
    private func setupPercentageInfo(percentageValue percentage : String, alphaValue : CGFloat){
        //Percentage gain or loss
        let percentageFloat = (percentage as NSString).floatValue
        let uptoTwoDecimalPercentage = String(format: "%.2f", percentageFloat)
        percentageLabel.text = uptoTwoDecimalPercentage + "%"
        
        //Setting up the percentageView
        setupPercentageView(percentage: percentageFloat, alphaValue: CGFloat(abs(alphaValue)))
    }
    
    //Setting up the percentage view
    private func setupPercentageView(percentage value : Float, alphaValue : CGFloat){
        
        //Setting up the rounded corner rectangle
        percentageView.layer.cornerRadius = 10
        percentageView.layer.masksToBounds = true
        
        //Ternary conditional opertator to set the color of the percentage background view
        percentageView.backgroundColor = value <= 0 ?
            (UIColor(named: Colors.loss.colorName())?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray) :
            UIColor(named: Colors.gain.colorName())?.withAlphaComponent(CGFloat(alphaValue)) ?? UIColor.lightGray
    }
}
