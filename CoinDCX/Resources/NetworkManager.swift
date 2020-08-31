//
//  NetworkManager.swift
//  CoinDCX
//
//  Created by ds-mayur on 31/8/2020.
//

import Foundation.NSURLSession
import Network

protocol NetworkConnectionStatus {
    func netwokResult(result : NetworkStatus)
}

final public class NetworkManager{
    
    //MARK:- Variables
    private let monitor = NWPathMonitor()
    static let shared = NetworkManager()
    
    //Defining the delegate protocol to pass the data from the Network Manager to Calling View Controller
    var networkDelegate : NetworkConnectionStatus?
    
    //MARK:- Computed Variables
    var status : NetworkStatus? {
        didSet{
            networkDelegate?.netwokResult(result: status!)
        }
    }
    
    
    //MARK:- Fetch Network Status Methods
    
    //Check whether user is connected to internet or not
    public func checkConnection() {
        
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                self.pingHost(Endpoint.google.getDomainURL())
            } else if path.status == .unsatisfied {
                self.status = .disconnected
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    //Ping host to check whether we are connected to internet or not
    private func pingHost(_ fullURL: String) {
        
        let url = URL(string: fullURL)
        
        let task = URLSession.shared.dataTask(with: url!) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    self.status = .connected
                }
            }else{
                self.status = .connectWithNoAccess
            }
        }
        
        task.resume()
    }
}

