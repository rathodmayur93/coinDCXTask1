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
    public var logoUrl : String?
    public var coinName : String?
    public var lastTradedPrice : String?
    public var percentage : String?
    public var lowPrice : String?
    public var highPrice : String?
    public var baseCurrency : String?
    public var targetCurrencyShortName : String?
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
        
        //Setting up the info
        setupInfo()
        
        //Setting up the percentageView
        setupPercentageView()
    }
    
    //Setting up the info
    private func setupInfo(){
        
        guard let vcPresenter = presenter, let atIndex = index else { return }
        
        //Loading the currency logo
        currencyLogo.loadSVG(url: Endpoints.imageUrl(coinName: vcPresenter.marketListModel?[atIndex].targetCurrencyShortName ?? "").path())
        
        //Setting the currency name
        currencyName.attributedText  = NSMutableAttributedString()
            .bold(vcPresenter.marketListModel?[atIndex].targetCurrencyName ?? "")
            .normal(" (" + (vcPresenter.marketListModel?[atIndex].targetCurrencyShortName ?? "") + ")")
        
        //Setting the last trade price of the coin
        let (lastPrice, percentage) = vcPresenter.getLastPriceAndPercentage(coinDCXName: vcPresenter.marketListModel?[atIndex].coindcxName ?? "")
        
        
        //Setting up the last traded price
        lastTradedPriceLabel.text = lastPrice + " " + (vcPresenter.marketListModel?[atIndex].baseCurrencyShortName ?? "")
        
        //Percentage gain or loss
        percentageLabel.text = percentage + "%"
        
        // Fetching & Setting the 24 hour high and low trade perice
        let (high, low) = vcPresenter.getHighAndLowPrice(coinDCXName: vcPresenter.marketListModel?[atIndex].coindcxName ?? "")
        lowLabel.text   = low
        highLabel.text  = high
    }
    
    //Setting up the percentage view
    private func setupPercentageView(){
        percentageView.layer.cornerRadius = 10
        percentageView.layer.masksToBounds = true
    }
}
