//
//  Constants.swift
//  WhatTo
//
//  Created by macmini on 08/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import Foundation
import UIKit




class Constants {
    
    
    
    
    //MARK:- Class
    static let app_delegate = ((UIApplication.shared.delegate as! AppDelegate))
    static let UserDefaults = Foundation.UserDefaults.standard
    
    //MARK:- UIColor Related
    static var Black:UIColor = UIColor.black
    static var White:UIColor = UIColor.white
    static var LightGray:UIColor = UIColor.lightGray
    static var DarkGray:UIColor = UIColor.darkGray
    static var Purple:UIColor = UIColor.purple
    static var Green:UIColor = UIColor.green
    static var Blue:UIColor = UIColor.blue
    static var Yellow:UIColor = UIColor.yellow
    static var Magenta:UIColor = UIColor.magenta
    static var Orange:UIColor = UIColor.orange
    static var Red:UIColor = UIColor.red
    static var Clear:UIColor = UIColor.clear
    
    
    //MARK:- Device frame
    static let screenSize = UIScreen.main.bounds
    static let WIDTH = screenSize.width
    static let HEIGHT = screenSize.height

    //MARK:- FONT
    //static let setFont(s) UIFont(name: "HelveticaNeue-Regular", size: CGFloat(s))
    
    /*
    #define setFont(s) [UIFont fontWithName:@"HelveticaNeue-Regular" size:s]
    #define setFontSemiBold(s) [UIFont fontWithName:@"HelveticaNeue-SemiBold" size:s]
    #define setFontMedium(s) [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
    #define setFontLight(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
    #define setFontItalic(s) [UIFont fontWithName:@"HelveticaNeue-Italic" size:s]
    #define setFontBold(s) [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
     */
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    

    static func shaodow(on subview: UIView) {
        subview.layer.shadowColor = UIColor.gray.cgColor
        subview.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(2.0))
        subview.layer.shadowRadius = 1
        subview.layer.shadowOpacity = 0.8
        subview.layer.cornerRadius = 0.0
        subview.layer.masksToBounds = false
    }

    static func setBorderTo(_ view: UIView, withBorderWidth widthView: Float, radiousView: Float, color bordercolor: UIColor) {
        view.layer.borderWidth = CGFloat(widthView)
        view.layer.borderColor = bordercolor.cgColor
        view.layer.cornerRadius = CGFloat(radiousView)
        view.layer.masksToBounds = true
    }

}
