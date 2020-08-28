//
//  ViewController.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import UIKit
import SVGKit

class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var twentyFourHourChangeLabel: UILabel!
    @IBOutlet weak var byCoinNameFilter: UIImageView!
    @IBOutlet weak var hourChangeFilter: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    
    private let dataSource = MarketListDataSource()
    private let delegate = MarketTableViewDelegate()
    
    /*
     - Setting up the viewController Presenter
     - We are using lazy keyword here since we want to intialize the presenter when its called for the first time
     */
    lazy var viewControllerPresener : ViewControllerPresener = {
        let presenter = ViewControllerPresener(marketDataSource: dataSource,
                                               marketDelegate: delegate)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI
        setUI()
        
        //Fetching the market detail from the server
        fetchMarketDetails()
    
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//        imageView.contentMode = .center
//        imageView.loadSVG(url: Endpoints.logoUrl.path())
//        self.navigationItem.titleView = imageView
    }
    
    //MARK:- UI Functions
    
    //Setting up the UI element
    private func setUI(){
        
        //Setting up the tableView
        setupTableView()
        
        //Setting up the delegate methods
        setupDelegates()
    }
    
    //Setting up the Tableview
    private func setupTableView(){
        
        //Setting tableView cell XIB
        setupTableViewXIB()
        
        tableView.dataSource = dataSource
        tableView.delegate   = delegate
    }
    
    //Setting up the tableView Cell XIB
    private func setupTableViewXIB(){
        tableView.register(UINib(nibName: StoryboardAnXIBEnum.marketDetailXIB.storyboardName(),
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.marketDetailCell)
        
    }
    
    //Setting up the delegate method
    private func setupDelegates(){
        viewControllerPresener.viewControllerDelegate = self
    }
    
    //Fetching the Market List from coinDCX api
    private func fetchMarketDetails(){
        viewControllerPresener.getMarketDetailsAPI()
    }
}

//MARK:- Extension Methods

//Implementing the viewController delegate protocol so that we can receive the data from the viewController Presenter
extension ViewController : ViewControllerDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func failedToLoadData() {
        print("We're facing some technical issue")
    }
}
