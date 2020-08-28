//
//  ViewControllerEnum.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

//MARK: ViewController Names Enum
enum ViewControllersEnum{
    
    case splash
    case home
    
    public func viewControllerName() -> String{
        
        switch self {
        case .splash:
            return "SplashViewController"
        case .home:
            return "ViewControllerNVC"
        }
    }
}

//MARK:- Storyboard And XIB Enums
enum StoryboardAnXIBEnum{
    
    case main
    case marketDetailXIB
    
    public func storyboardName() -> String{
        switch self {
        case .main:
            return "Main"
        case .marketDetailXIB:
            return "MarketTableViewCell"
        }
    }
}

//MARK:- TableViewCell Names
