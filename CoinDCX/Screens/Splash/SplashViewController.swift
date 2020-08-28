//
//  SplashViewController.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import UIKit
import SVGKit

class SplashViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK:- Variables
    private var timer               = Timer()
    private var time                = 0
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up UI
        setUI()
    }
    
    //MARK:- UI Functions
    
    //MARK: Setting up the UI
    private func setUI(){
        
        //Setting up the Logo
        setupLogo()
        
        //Setting up the timer
        setupTimer()
    }
    
    // Setting up the  Logo
    private func setupLogo(){
        
        //Loading the Logo of the coinDCX
        logoImageView.loadSVG(url: Endpoints.logoUrl.path())
    }
    
    
    // Setting up the timer
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(SplashViewController.goToScreen),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // SplashScreen Timer Function
    @objc func goToScreen(){
        //Increamenting the timer by 1
        time += 1

        /**
         - If condition will check whether time variable value is 1 or not i.e the time variable contain the second value
         - If the if condition is true then will navigate user to home screen
        **/
        if time == Constants.SPLASH_TIMER{
            Router.navigateScreen(from: self, to: ViewControllersEnum.home.viewControllerName())
        }
    }
    
}
