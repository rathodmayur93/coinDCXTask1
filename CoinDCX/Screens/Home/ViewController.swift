//
//  ViewController.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var twentyFourHourChangeLabel: UILabel!
    
    @IBOutlet weak var byCoinNameFilter: UIImageView!
    @IBOutlet weak var hourChangeFilter: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    
    private let dataSource = MarketListDataSource()
    private let delegate = MarketTableViewDelegate()
    private let filterDataSource = MarketFilterDataSource()
    private let filterDelegate = MarketFilterDelegate()
    private let searchDelegate = SearchMarketDataDelegate()
    
    /*
     - Setting up the viewController Presenter
     - We are using lazy keyword here since we want to intialize the presenter when its called for the first time
     */
    lazy var viewControllerPresener : ViewControllerPresener = {
        let presenter = ViewControllerPresener(marketDataSource: dataSource,
                                               marketDelegate: delegate,
                                               marketFilterDataSource: filterDataSource,
                                               marketFilterDelegate: filterDelegate,
                                               searchDataDelegate: searchDelegate)
        return presenter
    }()
    
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI
        setUI()
        
        //Fetching the market detail from the server
        fetchMarketDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Setup Netwok Listener
        NetworkManager.shared.networkDelegate = self
        NetworkManager.shared.checkConnection()
    }
    
    //MARK:- UI Functions
    
    //Setting up the UI element
    private func setUI(){
        
        //Setting up the tableView
        setupTableView()
        
        //Setting up the collectionView
        setupCollectionView()
        
        //Setting up the delegate methods
        setupDelegates()
        
        //Setting up the tap gesture
        setupTapGesture()
    }
    
    //Setting up the Tableview
    private func setupTableView(){
        
        //Setting tableView cell XIB
        setupTableViewXIB()
        
        tableView.dataSource = dataSource
        tableView.delegate   = delegate
        tableView.keyboardDismissMode = .onDrag
    }
    
    //Setting up the tableView Cell XIB
    private func setupTableViewXIB(){
        tableView.register(UINib(nibName: StoryboardAnXIBEnum.marketDetailXIB.storyboardName(),
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.marketDetailCell)
        
    }
    
    //Settnig up the collectionView
    private func setupCollectionView(){
        
        //Setting up the collectionView cell XIB
        setupCollectionViewXIB()
        
        collectionView.dataSource = filterDataSource
        collectionView.delegate = filterDelegate
    }
    
    //Setting up the collectionView cell XIB
    private func setupCollectionViewXIB(){
        collectionView.register(UINib(nibName: StoryboardAnXIBEnum.marketFilterXIB.storyboardName(),
                                      bundle: nil),
                                forCellWithReuseIdentifier: Constants.filterCell)
    }
    
    
    //Setting up the delegate method
    private func setupDelegates(){
        viewControllerPresener.viewControllerDelegate = self
        searchBar.delegate = searchDelegate
    }
    
    //Fetching the Market List from coinDCX api
    private func fetchMarketDetails(){
        viewControllerPresener.getMarketDetailsAPI()
    }
    
    private func showNoInternetAlertBox(message: String){
        // Create the alert controller
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Retry Now", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            //Check internet connection now
            NetworkManager.shared.checkConnection()
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Tap Gestures
    //Setting up the tap gesture
    private func setupTapGesture(){
        
        //Setting up the colum tap gesture
        setupColumnTapGesture()
        
        //Setting up the hour change tap gesture
        setupChangeTapGesture()
    }
    
    //Setting up the column name tap gesture
    private func setupColumnTapGesture(){
        
        let columnTapGesture = UITapGestureRecognizer(target: self, action: #selector(columnTapAction))
        columnTapGesture.numberOfTouchesRequired = 1
        
        coinNameLabel.isUserInteractionEnabled = true
        byCoinNameFilter.isUserInteractionEnabled = true
        
        coinNameLabel.addGestureRecognizer(columnTapGesture)
        byCoinNameFilter.addGestureRecognizer(columnTapGesture)
        
    }
    
    //Setting up the change tap gesture
    private func setupChangeTapGesture(){
        
        let hourChangeTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTapAction))
        hourChangeTapGesture.numberOfTouchesRequired = 1
        
        twentyFourHourChangeLabel.isUserInteractionEnabled = true
        hourChangeFilter.isUserInteractionEnabled = true
        
        twentyFourHourChangeLabel.addGestureRecognizer(hourChangeTapGesture)
        hourChangeFilter.addGestureRecognizer(hourChangeTapGesture)
    }
    
    //MARK:- Tap Gesture Action
    
    //Column Tap Action Method
    @objc private func columnTapAction(){
        viewControllerPresener.isColumnFilterSelected.toggle()
    }
    
    //Change action method
    @objc private func changeTapAction(){
        viewControllerPresener.isHourChangeFilterSelected.toggle()
    }
}

//MARK:- Extension Methods

//Implementing the viewController delegate protocol so that we can receive the data from the viewController Presenter
extension ViewController : ViewControllerDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
        
        //While filtering the data if the marketListModel count becomes zero then it cant scroll up and it will result into the crash to avoid that we are putting this check
        if(viewControllerPresener.marketListModel?.count != 0){
            //Whenever tableView reload again will scroll the tableView to the top for better UX
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func selectTableViewRow(at : Int) {
        Router.showCoinBottomSheet(from: self, presenter: viewControllerPresener, at: at)
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func changeColumnFilterIcon() {
        byCoinNameFilter.image = viewControllerPresener.isColumnFilterSelected ? UIImage(named: "ascendingArrow") : UIImage(named: "desecendingArrow")
        hourChangeFilter.image = UIImage(named: "unselectedArrow")
    }
    
    func changePercentageFilterIcon() {
        hourChangeFilter.image = viewControllerPresener.isHourChangeFilterSelected ? UIImage(named: "ascendingArrow") : UIImage(named: "desecendingArrow")
        byCoinNameFilter.image = UIImage(named: "unselectedArrow")
    }
    
    func handleError(error: ErrorResult) {
        let message = Utility.retrieveErrorMessage(errorResult: error)
        Utility.showAlert(title: "Oops!", message: message, logMessage: message, fromController: self)
    }
}

//MARK:- Extension For Protocol NetworkConnectionStatus
extension ViewController : NetworkConnectionStatus{
    func netwokResult(result: NetworkStatus) {
        DispatchQueue.main.async {
            if(result != .connected){
                self.showNoInternetAlertBox(message: result.getStatusMessage())
            }
        }
    }
}
