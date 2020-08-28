//
//  RequestFactory.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//  Copyright © 2020 Mayur Rathod. All rights reserved.
//

import Foundation

/*
 - We are making this class as final since we want to prevent this class to be subclassed
 - Marking class as final also tells swift compiler that method should be called directly (static dispatch) instead of the dynamic dispatch.
 - Bcoz of the static dispatch it will reduce the function call overhead and gives you extra performance
*/
final class RequestFactory {
    
    /**
     This method returns the URLRequest
     
     - parameter method: RequestMethod i.e GET, POST, PUT etc
     - parameter url: URL of api endpoint
     - returns: URLRequest of the request request url
    */
    static func request(method: RequestMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}
