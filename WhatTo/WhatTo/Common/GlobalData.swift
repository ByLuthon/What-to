//
//  GlobalData.swift
//
//
//  Created by rlogical on 21/02/2017.
//  Copyright (c) 2017 rlogical. All rights reserved.
//

import UIKit
import SystemConfiguration


extension UINavigationController {
    
    func push(viewController: UIViewController, animated: Bool) {
        _ = navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}

extension UIView {
    func useUnderline(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}


extension NSLocale {
    class func locales1(countryName1 : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode)
            if countryName1.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
}


class GlobalData: NSObject {
    
    // MARK: - ReachabilityStatus
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    // MARK: - internetReachabilityStatus
   static var internetReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    
    // MARK: - readPropertyList
    static func readPropertyList(plistFileName : String) -> NSDictionary {
        
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = Bundle.main.path(forResource: plistFileName, ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
            //print(plistData)
            return plistData as NSDictionary
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
            return plistData as NSDictionary
        }
    }

    
    
    
    // MARK: - Create Serialized Query string from Dictionary
    static func serializedQueryStringFromDictionary(dictJson : NSDictionary) -> String {
        
        let keys = dictJson.flatMap(){ $0.0 as? String }
        let values = dictJson.flatMap(){ $0.1 }
        let keyArray : NSArray = keys as NSArray
        let valueArray : NSArray = values as NSArray
        var strFinal : String = ""
        for i in 0..<keyArray.count {
            var strValue = String()
            if valueArray[i] is NSNull {
                strValue = ""
            } else {
                strValue = "\(valueArray[i])"
            }
            
            if (strFinal == "") {
                strFinal = String(format: "%@=%@","\(keyArray[i])","\(strValue)")
            } else {
                strFinal = String(format: "%@&%@=%@",strFinal,"\(keyArray[i])","\(strValue)")
            }
        }
        return strFinal
    }
    
    
    
    // MARK: - Set Attributed String
    static func setAttributedString(strFirstText: String , strSectionText: String) -> NSAttributedString{
        
        let yourAttributes = [NSForegroundColorAttributeName: Constants.hexStringToUIColor(hex: "6D797A"), NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size:22)]
        let yourOtherAttributes = [NSForegroundColorAttributeName: Constants.hexStringToUIColor(hex: "43A5F6"), NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)]
        let partOne = NSMutableAttributedString(string: strFirstText, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: strSectionText, attributes: yourOtherAttributes)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        
        return combination
    }
    
    // MARK: - Convert JSON Dictionary to String
    static func convertDictionaryToString(dictJson : NSDictionary) -> String {
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictJson,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            return theJSONText!
        }
        return ""
    }
}
