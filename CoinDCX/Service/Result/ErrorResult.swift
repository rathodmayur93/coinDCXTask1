//
//  ErrorResult.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//  Copyright © 2020 Mayur Rathod. All rights reserved.
//

/*
    - Whenever we face any issues while making an api call or in api response one of the following enum cases will be return as an error
*/
enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
