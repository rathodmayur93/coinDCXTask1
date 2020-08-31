//
//  Utility.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import Foundation
import UIKit

struct Utility {
    
    //Loader Views
    static let spinningActivityIndicator: UIActivityIndicatorView  = UIActivityIndicatorView()
    static let container: UIView                                   = UIView()
    
    
    //MARK: Show Indicator Loader while making an api call
    //Reference from the StackOverflow
    static func showIndicatorLoader(){
        
        let window                      = UIApplication.shared.keyWindow
        container.frame                 = UIScreen.main.bounds
        container.backgroundColor       = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.4)
        
        let loadingView: UIView         = UIView()
        loadingView.frame               = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center              = container.center
        loadingView.backgroundColor     = UIColor.gray
        loadingView.clipsToBounds       = true
        loadingView.layer.cornerRadius  = 40
        
        spinningActivityIndicator.frame                         = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinningActivityIndicator.hidesWhenStopped              = true
        spinningActivityIndicator.style  = UIActivityIndicatorView.Style.whiteLarge
        spinningActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(spinningActivityIndicator)
        container.addSubview(loadingView)
        window?.addSubview(container)
        spinningActivityIndicator.startAnimating()
    }
    
    //MARK:- Hide loader when receive the response form the api call
    static func hideIndicatorLoader(){
        DispatchQueue.main.async {
            self.spinningActivityIndicator.stopAnimating()
            self.container.removeFromSuperview()
        }
    }
    
    //MARK:- Show alert dialog with title & message
    static func showAlert(title: String, message: String, logMessage: String, fromController controller: UIViewController){
        let alertController = UIAlertController(title: title,
                                                message:message,
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default,handler: nil))
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Fetching the errorMessage from teh ErrorResult Enum property
    static func retrieveErrorMessage(errorResult : ErrorResult) -> String{
        
        switch errorResult{
        case .custom(let value):
            return value
        case .network(let value):
            return value
        case .parser(let value):
            return value
        }
    }
}
