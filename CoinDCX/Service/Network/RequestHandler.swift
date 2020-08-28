//
//  RequestHandler.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//  Copyright © 2020 Mayur Rathod. All rights reserved.
//

import Foundation

class RequestHandler {
    
    func networkResultData<T : Codable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) -> ((Result<Data, ErrorResult>) -> Void){
        
        return { dataResult in
            
            DispatchQueue.global(qos: .background).async(execute: {
                
                switch dataResult{
                case .success(let data):
                    //Converting the data into the Respective model
                    guard let list = try? JSONDecoder().decode(T.self, from: data) else {
                        return completion(.failure(.parser(string: "Unable to parse data ")))
                    }
                    completion(.success(list))
                case .failure(let error):
                    // Handling the error events
                    print("Network Error \(error)")
                    completion(.failure(.parser(string: "Unable to parse data " + error.localizedDescription)))
                    break
                }
            })
        }
    }
}
