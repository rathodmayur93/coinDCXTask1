//
//  Router.swift
//  CoinDCX
//
//  Created by ds-mayur on 26/8/2020.
//

import UIKit.UIViewController

final class Router{
    
    //MARK:- Navigate to the Movie Detail Screen
    static func navigateScreen(from controller : UIViewController, to viewControllerIdentifier : String){
        
        //Fetching the storyBoard and creating the MovieDetailViewController object
        let mainStoryboard         = UIStoryboard(name: StoryboardAnXIBEnum.main.storyboardName(), bundle: Bundle.main)
        let vc : UIViewController  = mainStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as UIViewController

        vc.modalPresentationStyle   = .fullScreen
        vc.modalTransitionStyle     = .crossDissolve
        
        //For Navigation Controller push the ViewController using below line
        //controller.navigationController?.pushViewController(vc, animated: true)
        
        //Navigate to the movie detail screen
        controller.present(vc, animated: true, completion: nil)
    }
}
