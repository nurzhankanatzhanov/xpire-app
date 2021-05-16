//
//  SubstringFormatting.swift
//  XPIRE
//
//  Created by Nurzhan Kanatzhanov on 4/4/21.
//

import Foundation
import UIKit

// idea from https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift
public extension NSMutableAttributedString {
    var fontSize: CGFloat { return 18 }
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont.systemFont(ofSize: fontSize) }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
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
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func boldAndUnderlined(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func customGreen(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .foregroundColor : UIColor(red: CGFloat(51/255.0), green: CGFloat(142/255.0), blue: CGFloat(86/255.0), alpha: 1),
            .backgroundColor: UIColor.white
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
