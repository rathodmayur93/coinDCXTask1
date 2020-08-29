//
//  AllExtension.swift
//  CoinDCX
//
//  Created by ds-mayur on 27/8/2020.
//

import UIKit.UIImageView
import SDWebImageSVGKitPlugin

extension UIImageView{
    
    //Load the SVG image
    func loadSVG(url : String){
        
        let imageUrl = URL(string: url)
        let svgCoder = SDImageSVGKCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)
        self.sd_setImage(with: imageUrl)
    }
}

extension NSMutableAttributedString {
    var fontSize : CGFloat { return 16 }
    var normalFontSize : CGFloat { return 6 }
    var boldFont : UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont : UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: normalFontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .foregroundColor : UIColor(named: Colors.textColor.colorName()) ?? UIColor.gray
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
