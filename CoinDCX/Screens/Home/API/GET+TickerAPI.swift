//
//  GET+TickerAPI.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation

protocol GetTickerServiceProtocol{
    func getTickerDetail(_ completion : @escaping ((Result<[TickerModel], ErrorResult>) -> Void))
    func cancelGetMarketDetails()
}

class GetTickerAPI : RequestHandler, GetTickerServiceProtocol{
    
    //MARK:- Variables
    //Creating the singleton instance of the FetchMoviesService
    static let shared = GetTickerAPI()
    
    //Variabels
    let tickerEndpoint = Endpoints.ticker.path()
    var task : URLSessionTask?
    
    //MARK:- Protocol Methods
    func getTickerDetail(_ completion: @escaping ((Result<[TickerModel], ErrorResult>) -> Void)) {
        
        // cancel previous request if already in progress
        self.cancelGetMarketDetails()
        
        task = RequestService().loadData(urlString: tickerEndpoint,
                                         parameters: [:],
                                         completion: self.networkResultData(completion: completion))
    }
    
    func cancelGetMarketDetails() {
        
        if let task = task {
            task.cancel()
        }
        task = nil
    }
    
    
}
