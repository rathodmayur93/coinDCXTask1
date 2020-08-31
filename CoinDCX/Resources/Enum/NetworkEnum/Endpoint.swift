//
//  Endpoint.swift
//  InternetConnection
//
//  Created by ds-mayur on 31/8/2020.
//

enum Endpoint {
    
    case google
    
    //Get the URL of the endpoint
    public func getDomainURL() -> String{
        switch self {
        case .google:
            return "https://www.google.com"
        }
    }
}
