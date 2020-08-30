//
//  ViewControllerPresenter.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation
import UIKit.UIViewController

protocol ViewControllerDelegate {
    func reloadTableView()
    func failedToLoadData()
    func selectTableViewRow(at index : Int)
    func reloadCollectionView()
    func changeColumnFilterIcon()
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
    
    private weak var searchDelegate : SearchMarketDataDelegate?
    
    //Storing the original result of market detail list and ticker list
    private var originalMarketList : [MarketDetailModel]?
    private var originalTicketList : [TickerModel]?
    
    //Storing whether which filter user have selected
    private lazy var isColumFilterSelectedFlag = false
    private lazy var isChangeFilterSelectedFlag = false
    
    //MARK: Computation Variables
    public var errorResult : ErrorResult? {
        
        didSet{
            print("Setting Error Result Successfully")
            print(errorResult!)
        }
    }
    
    public var marketListModel : [MarketDetailModel]? {
        
        didSet{
            //Passing the data from the presenter to the viewController
            viewControllerDelegate?.reloadTableView()
        }
    }
    
    public var tickerModelList : [TickerModel]? {
        
        didSet{
            //Passing the data from the presenter to the viewController
            viewControllerDelegate?.reloadTableView()
        }
    }
    
    public var filterList : [FilterModel]? {
        
        didSet{
            //Passing the data from the presenter to the viewController
            viewControllerDelegate?.reloadCollectionView()
        }
    }
    
    //Flag for sorting the data in ascending and decending order
    
    public var isColumnFilterSelected : Bool {
        
        willSet{
            columSortAction(columnFilterFlag: newValue)
        }
    }
    
    public var isHourChangeFilterSelected : Bool? {
        didSet{
            
        }
    }
    
    
    //MARK:- Initializer
    init(marketService : GetMarketDetailServiceProtocol = GetMarketDetailsAPI.shared,
         tickerService : GetTickerServiceProtocol = GetTickerAPI.shared,
         marketDataSource : MarketListDataSource,
         marketDelegate : MarketTableViewDelegate,
         marketFilterDataSource : MarketFilterDataSource,
         marketFilterDelegate : MarketFilterDelegate,
         searchDataDelegate : SearchMarketDataDelegate)
    {
        self.marketDetailService = marketService
        self.tickerDetailService = tickerService
        self.dataSource = marketDataSource
        self.delegate = marketDelegate
        self.colletionDataSource = marketFilterDataSource
        self.collectionDelegate = marketFilterDelegate
        self.searchDelegate = searchDataDelegate
        
        //Setting up the filter flag as false
        isColumnFilterSelected = false
        
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
    
    //Fetch the High & Low price from the ticker object
    public func getHighAndLowPrice(coinDCXName name : String) -> (high : String, low : String){
        
        let tickerModel = tickerModelList?.first(where: { (tickerModel) -> Bool in
            return tickerModel.market == name
        })
        
        return (tickerModel?.high ?? "", tickerModel?.low ?? "")
    }
    
    //Fetch the alpha value of the percetage overlay view
    public func fetchAlphaValue(percentage value : Float) -> Float{
        switch value {
        case 0..<5:
            return 0.5
        case 5..<10:
            return 0.6
        case 10..<15:
            return 0.7
        case 15..<20:
            return 0.75
        case 20..<25:
            return 0.8
        case 25..<30:
            return 0.85
        case 30..<40:
            return 0.9
        default:
            return 1.0
        }
    }
    
    //Fetch the filter list
    private func fetchFilterList() {
        
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
        
        //Setting value to the filterList
        filterList = list
    }
    
    //MARK:- Common Functions
    private func passDataToDataSource(){
        
        //Passing reference to tableView
        dataSource?.viewControllerPresenter = self
        delegate?.viewControllerPresenter = self
        
        //Passsing reference to collectionView
        colletionDataSource?.viewControllerPresenter = self
        collectionDelegate?.viewControllerPresenter = self
        
        //Passing reference to search bar
        searchDelegate?.viewControllerPresenter = self
    }
    
    //Change the selected filter
    public func changeFilter(selectedAt index : Int){
        
        // Unwrapping the fitler list. If filter list is nil  then will return and stop the execution of the code
        guard var list = filterList else { return }
        
        // Will loop through all the filter and will make selected filer flag true
        for i in 0..<list.count{
            if(i == index){
                list[i].isFilterSelected = true
            }else{
                list[i].isFilterSelected = false
            }
        }
        
        //Will assign the new list with user selected filter to filter list so that it can refresh the collectionView
        filterList = list
        
        //Whenever filter gets change we have to load filtered market data
        filterMarketData(filterName: list[index].filterName)
    }
    
    //MARK: Filtering Market Data
    
    // Filter out the market data based on the selected BASE CURRENCY SHORT NAME
    private func filterMarketData(filterName baseCurrencyShortName: String){
        
        //Unwrapping & Assigning the original list to new variable so that we can peroforn filter operation on that
        guard let list = originalMarketList else { return }
        
        /*
         - If the select filter is ALL then we have to load all the data we fetched from the server wiithout applying any filter
         - Else will filter the data based on the BASE CURRENCY SHORT NAME
         */
        if(baseCurrencyShortName == "ALL"){
            marketListModel = originalMarketList
        }else{
            marketListModel = list.baseCurrencyFilter(baseCurrencyShortName: baseCurrencyShortName)
        }
        
        //If the user have selectd any filter then we will maintain that filter while applying above filter
        if(isColumFilterSelectedFlag){
            columSortAction(columnFilterFlag: isColumnFilterSelected)
        }
    }
    
    //MARK: Column Filter Methods
    
    //Sort the market data based on the columFilterFlag
    private func columSortAction(columnFilterFlag flag : Bool){
        
        //Sort the data depending on the column filter flag
        if(flag){
            sortByTargetCurrencyInDecendingOrder()
        }else{
            sortByTargetCurrencyInAscendingOrder()
        }
        
        //Make Column filter selected
        isColumFilterSelectedFlag = true
        
        // Notify the viewController to change the column filter icon
        viewControllerDelegate?.changeColumnFilterIcon()
    }
    
    // Sort the data in Ascending Order based on the Target Currency Name
    private func sortByTargetCurrencyInAscendingOrder(){
        if let list = marketListModel {
            marketListModel = list.sortAscending()
        }
    }
    
    // Sort the data in Decending Order based on the Target Currency Name
    private func sortByTargetCurrencyInDecendingOrder(){
        if let list = marketListModel{
            marketListModel = list.sortDecending()
        }
    }
    
    //MARK: Change Percentage Filter
    
    //Sort the market data based on the 24 hour change rate
    private func percentageChangeSortAction(columnFilterFlag flag : Bool){
        
        //Sort the data depending on the column filter flag
        if(flag){
            sortByTargetCurrencyInDecendingOrder()
        }else{
            sortByTargetCurrencyInAscendingOrder()
        }
        
        //Make Column filter selected
        isColumFilterSelectedFlag = true
        
        // Notify the viewController to change the column filter icon
        viewControllerDelegate?.changeColumnFilterIcon()
    }
    
    //MARK: Search Text Data Filter
    //Filter the data based on the Searched Text
    public func filterSearchedData(searchedText text : String){
        
        //If the search text is blank mean we have to load the original result again since user is not searching anything anymore
        if(text == ""){
            marketListModel = originalMarketList
            return
        }
        
        //Filter the list based on target currency name
        if let list = originalMarketList{
            marketListModel = list.searchedhData(searchText: text)
        }
    }
    
    //MARK:- TableView Row Selection Method
    
    //When user click on the tableView row this method will get invoked
    public func didSelectTableViewRow(at index : Int){
        viewControllerDelegate?.selectTableViewRow(at: index)
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
                    self.originalMarketList = marketDetailModel
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
                    self.originalTicketList = tickerModel
                    //Fetchinig the filter list based on the base currency pair
                    self.fetchFilterList()
                case .failure(let error):
                    self.errorResult = error
                }
                
                //Hide the indicator loader
                Utility.hideIndicatorLoader()
            }
        }
    }
}
