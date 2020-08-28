//
//  ViewControllerPresenter.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

protocol ViewControllerDelegate {
    func reloadTableView()
    func failedToLoadData()
    func reloadCollectionView()
}

class ViewControllerPresener {
    
    //MARK:- Variables
    private var marketDetailService  : GetMarketDetailServiceProtocol?
    private var tickerDetailService  : GetTickerServiceProtocol?
    
    //Defining the delegate protocol to pass the data from the presenter to viewController
    var viewControllerDelegate : ViewControllerDelegate?
    
    //Defining the weak property here to avoid the Strong Reference Cycle which can cause memmory leak
    private weak var dataSource : MarketListDataSource?
    private weak var delegate   : MarketTableViewDelegate?
    
    private weak var colletionDataSource : MarketFilterDataSource?
    private weak var collectionDelegate  : MarketFilterDelegate?
    
    
    //MARK: Computation Variables
    public var errorResult : ErrorResult? {
        didSet{
            print("Setting Error Result Successfully")
            print(errorResult!)
        }
    }
    
    public var marketListModel : [MarketDetailModel]? {
        didSet{
            print("Market List Value Set")
            print(marketListModel?.count ?? 0)
        }
    }
    
    public var tickerModelList : [TickerModel]? {
        didSet{
            
            //Passing the data from the presenter to the viewController
            viewControllerDelegate?.reloadTableView()
            viewControllerDelegate?.reloadCollectionView()
        }
    }
    
    var filterList : [FilterModel]? {
        
        get{
            return fetchFilterList()
        }
    }
    
    //MARK:- Initializer
    init(marketService : GetMarketDetailServiceProtocol = GetMarketDetailsAPI.shared,
         tickerService : GetTickerServiceProtocol = GetTickerAPI.shared,
         marketDataSource : MarketListDataSource,
         marketDelegate : MarketTableViewDelegate,
         marketFilterDataSource : MarketFilterDataSource,
         marketFilterDelegate : MarketFilterDelegate)
    {
        self.marketDetailService = marketService
        self.tickerDetailService = tickerService
        self.dataSource = marketDataSource
        self.delegate = marketDelegate
        self.colletionDataSource = marketFilterDataSource
        self.collectionDelegate = marketFilterDelegate
        
        //Passing the reference of the presenter to the dataSource class
        passDataToDataSource()
    }
    
    //MARK:- Functions to fetch values
    
    //Fetch the coin information from the market detail object
    public func getCoinMarketInfo(at index : Int) -> (baseCurrencyShort : String, targetCurrencyShort : String, name : String, dcxName : String, imageUrl : String){
        
        return (marketListModel?[index].baseCurrencyShortName ?? "",
                marketListModel?[index].targetCurrencyShortName ?? "",
                (marketListModel?[index].targetCurrencyName ?? ""),
                (marketListModel?[index].coindcxName ?? ""),
                Endpoints.imageUrl(coinName: marketListModel?[index].targetCurrencyShortName ?? "").path())
    }
    
    //Fetch the coin information from the ticker object
    public func getLastPriceAndPercentage(coinDCXName name : String) -> (lastPrice : String, percentage : String){
        
        let tickerModel = tickerModelList?.first(where: { (tickerModel) -> Bool in
            return tickerModel.market == name
        })
        
        return (tickerModel?.lastPrice ?? "", tickerModel?.change24_Hour ?? "")
    }
    
    
    //Fetch the alpha value of the percetage overlay view
    public func fetchAlphaValue(percentage value : Float) -> Float{
        switch value {
        case 0..<10:
            return 0.5
        case 10..<20:
            return 0.6
        case 20..<30:
            return 0.7
        case 30..<40:
            return 0.8
        default:
            return 0.9
        }
    }
    
    //Fetch the filter list
    private func fetchFilterList() -> [FilterModel]{
        
        var list = [FilterModel]()
        
        //Grouping the common base currency short name
        let grouping = Dictionary(grouping: marketListModel ?? []) { (ticker) -> String in
            return (ticker.baseCurrencyShortName ?? "")
        }
        
        //Looping throught the each element and adding it in string array
        for key in grouping.keys{
            
            list.append(FilterModel(filterName: key, isFilterSelected: false))
        }
        
        list.insert(FilterModel(filterName: "ALL", isFilterSelected: true), at: 0)
        return list
    }
    
    //MARK:- Common Functions
    private func passDataToDataSource(){
        dataSource?.viewControllerPresenter = self
        colletionDataSource?.viewControllerPresenter = self
    }
    
    
    //MARK:- API Calls
    
    //Fetching the market detail from the coinDCX API
    func getMarketDetailsAPI(){
        
        //Check whether internet connection is there or not
        if !InternetConnectionManager.isConnectedToNetwork(){
            print("No Internet Connection")
            errorResult = ErrorResult.custom(string: "No Internet Connection")
            return
        }
        
        //Unwrapping the service
        guard let marketServiceUnwrap = marketDetailService else {
            errorResult = ErrorResult.custom(string: "Missing Service")
            return
        }
        
        //Showing Loader
        Utility.showIndicatorLoader()
        
        //Fetching the market detail by making an api call
        marketServiceUnwrap.getMarketDetail { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let marketDetailModel):
                    self.marketListModel = marketDetailModel
                    
                    //Fetching the ticket information from the coinDCX
                    self.getTickerDetailAPI()
                case .failure(let error):
                    self.errorResult = error
                    
                    //Hide the indicator loader
                    Utility.hideIndicatorLoader()
                }
            }
        }
    }
    
    
    //Fetching the ticker detail from the coinDCX API
    func getTickerDetailAPI(){
        
        //Check whether internet connection is there or not
        if !InternetConnectionManager.isConnectedToNetwork(){
            print("No Internet Connection")
            errorResult = ErrorResult.custom(string: "No Internet Connection")
            return
        }
        
        //Unwrapping the service
        guard let tickerServiceUnwrap = tickerDetailService else {
            errorResult = ErrorResult.custom(string: "Missing Service")
            return
        }
        
        //Showing Loader
        Utility.showIndicatorLoader()
        
        //Fetching the market detail by making an api call
        tickerServiceUnwrap.getTickerDetail { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let tickerModel):
                    self.tickerModelList = tickerModel
                case .failure(let error):
                    self.errorResult = error
                }
                
                //Hide the indicator loader
                Utility.hideIndicatorLoader()
            }
        }
    }
}
