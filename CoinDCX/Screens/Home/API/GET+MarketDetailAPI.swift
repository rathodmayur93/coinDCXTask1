//
//  GET+MarketDetailAPI.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

protocol GetMarketDetailServiceProtocol{
    func getMarketDetail(_ completion : @escaping ((Result<[MarketDetailModel], ErrorResult>) -> Void))
    func cancelGetMarketDetails()
}


class GetMarketDetailsAPI : RequestHandler, GetMarketDetailServiceProtocol {
    
    //MARK:- Variables
    
    //Creating the singleton instance of the FetchMoviesService
    static let shared = GetMarketDetailsAPI()
    
    //Variabels
    let marketDetailEndpoint = Endpoints.marketDetail.path()
    var task : URLSessionTask?
    
    
    //MARK:- Protocol Methods
    func getMarketDetail(_ completion: @escaping ((Result<[MarketDetailModel], ErrorResult>) -> Void)) {
        // cancel previous request if already in progress
        self.cancelGetMarketDetails()
        
        task = RequestService().loadData(urlString: marketDetailEndpoint,
                                         parameters: [:],
                                         completion: self.networkResultData(completion: completion))
    }
    
    // Cancel the get market detail task
    func cancelGetMarketDetails() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
