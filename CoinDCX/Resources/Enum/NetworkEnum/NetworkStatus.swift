//
//  NetworkStatus.swift
//  InternetConnection
//
//  Created by ds-mayur on 31/8/2020.
//

enum NetworkStatus{
    case connected
    case disconnected
    case connectWithNoAccess
    
    func getStatusMessage() -> String{
        switch self {
        case .connected:
            return "WE'RE CONNECTED"
        case .disconnected:
            return "WE'RE NOT CONNECTED"
        case .connectWithNoAccess:
            return "WE'RE CONNECTED BUT NO INTERNET CONNECTION"
        }
    }
}
