//
//  RequestService.swift
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
final class RequestService {

     /**
        This method returns the URLRequest
        
        - parameter urlString: API url endpint in string format
        - parameter session: URLSession configuration
        - parameter parameters : Request parameters while making an api call
        - parameter completion: completion method of type Result<Data, ErrorResult>
        - returns: URLSessionTask of the request api url
       */
    func loadData(urlString: String,
                  session: URLSession = URLSession(configuration: .default),
                  parameters: [String : String],
                  completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask?
    {
        
        //Creating the URL Componenet
        guard var component = URLComponents(string: urlString) else {
            completion(.failure(.custom(string: "Wrong url format")))
            return nil
        }
        
        //Appending the query parameters into the URL
        component.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        //Fetching the URL with query parameters
        guard let requestedUrl = component.url else{
            completion(.failure(.network(string: "Unable to fetch URL")))
            return nil
        }
        
        print("API URL : \(requestedUrl)")
        
        //Creating the URLRequest
        let request = RequestFactory.request(method: .GET, url: requestedUrl)
        
        //Making an data request using URLRequest
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //If response contains an error
            if let error = error {
                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }
            
            //If the api call is successfull and we got the api response
            if let data = data {
                completion(.success(data))
            }
        }
        
        task.resume()
        return task
    }
}
