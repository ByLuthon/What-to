//
//  AppDelegate.swift
//  WhatTo
//
//  Created by macmini on 08/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITableViewDelegate,UITableViewDataSource {

    var window: UIWindow?
   
    var sidebarview: UIView!
    var lblsidebarBG : UILabel!
    
    
    var arrSideMenu : NSMutableArray!
    var arrselectLocation : NSMutableArray = []
    //var arrselectLocation = [Any]() as! NSMutableArray

    var HomeDict : NSMutableDictionary!
    var WorkDict : NSMutableDictionary!
    
    var PickupLocation = CLLocationCoordinate2D()
    var DestinationLocation = CLLocationCoordinate2D()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        //GoogleMaps
        initGoogleMaps()
        
        //set IQKeyboard Manager
        IQKeyboardManager.sharedManager().enable = true
        
        //SIDE Menu
        self.createSideMenu()
        
        // Override point for customization after application launch.
        return true
    }

    func initGoogleMaps()
    {
        GMSServices.provideAPIKey(GoogleMapsAPIKey.GMS_API_KEY)
        GMSPlacesClient.provideAPIKey(GoogleMapsAPIKey.GMSPLACES_API_KEY)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - Side Menu
    func createSideMenu()
    {
        //sidebarview.removeFromSuperview()
        let path: String? = Bundle.main.path(forResource: "sideMenuList", ofType: "plist")
        
        arrSideMenu = NSArray(contentsOfFile: path!) as! NSMutableArray
        
        sidebarview = UIView(frame: UIScreen.main.bounds)
        sidebarview.backgroundColor = UIColor.clear
        
        lblsidebarBG = UILabel(frame: sidebarview.frame)
        lblsidebarBG.backgroundColor = UIColor.black
        lblsidebarBG.alpha = 0.0
        sidebarview.addSubview(lblsidebarBG)
        
        let subviewBG = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH - 80), height: CGFloat(UIScreen.main.bounds.size.height)))
        subviewBG.backgroundColor = UIColor.white
        sidebarview.addSubview(subviewBG)

        
        let btnhide = UIButton(type: .custom)
        btnhide.frame = sidebarview.frame
        /*btnhide.onTouchUpInside = {(sender: Any, event: UIEvent) -> Void in
            self.closeSideMenu()
        } as? UIEventBlock*/
        btnhide.addTarget(self, action:#selector(self.pressed), for: .touchUpInside)
        sidebarview.addSubview(btnhide)
        

        let viewTopProfile = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH - 80), height: CGFloat(100)))
        viewTopProfile.backgroundColor = UIColor.black
        sidebarview.addSubview(viewTopProfile)
        
        let imgprofile = UIImageView(frame: CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(60), height: CGFloat(60)))
        imgprofile.image = UIImage(named: "emptyProfilePic.png")
        //imgprofile.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "emptyProfilePic.png"))
        Constants.setBorderTo(imgprofile, withBorderWidth: 1.0, radiousView: Float(imgprofile.frame.size.height / 2), color: UIColor.white)
        viewTopProfile.addSubview(imgprofile)
        
        
        let lblUsername = UILabel(frame: CGRect(x: CGFloat(80), y: CGFloat(30), width: CGFloat(193), height: imgprofile.frame.size.height))
        lblUsername.textColor = UIColor.white
        lblUsername.text = "Bhavesh Nayi"
        lblUsername.font = UIFont(name: "HelveticaNeue-Regular", size: CGFloat(16))
        viewTopProfile.addSubview(lblUsername)
        
        
        let btnProfile = UIButton(type: .custom)
        btnProfile.frame = viewTopProfile.frame
        btnProfile.addTarget(self, action:#selector(self.editProfileTapped), for: .touchUpInside)
        viewTopProfile.addSubview(btnProfile)

        
        let tbl = UITableView(frame: CGRect(x: CGFloat(0), y: CGFloat(viewTopProfile.frame.size.height+10), width: CGFloat(viewTopProfile.frame.size.width), height: CGFloat(Constants.HEIGHT - viewTopProfile.frame.size.height)), style: .plain)
        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = UIColor.clear
        tbl.separatorStyle = .none
        sidebarview.addSubview(tbl)
        tbl.reloadData()

        window?.addSubview(sidebarview)
        sidebarview.isHidden = true
    }
    
    func pressed(sender: UIButton!)
    {
        self.closeSideMenu()
    }

    func editProfileTapped(sender: UIButton!)
    {
        self.closeSideMenu()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "EditAccountViewController") as! EditAccountViewController
        //self.present(vc, animated: true, completion: nil)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }

    
    func openSideMenu()
    {
        window?.bringSubview(toFront: sidebarview)
        sidebarview.isHidden = false
        sidebarview.frame = CGRect(x: CGFloat(-Constants.WIDTH), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(Constants.HEIGHT))
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.4)
        sidebarview.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(Constants.HEIGHT))
        UIView.commitAnimations()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.lblsidebarBG.alpha = 0.2
        })
    }

    
    func closeSideMenu()
    {
        self.lblsidebarBG.alpha = 0.0
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.4)
        sidebarview.frame = CGRect(x: CGFloat(-Constants.WIDTH), y: CGFloat(0), width: Constants.WIDTH, height: CGFloat(Constants.HEIGHT))
        UIView.commitAnimations()
    }
    
    
    // MARK: - Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrSideMenu.count
    }
    
    // Customize the appearance of table view cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier)
        }
     
        
        let dictCell = arrSideMenu.object(at: indexPath.row) as! NSDictionary
        cell?.textLabel?.text = dictCell.value(forKey: "title") as? String
        cell?.textLabel?.textColor = UIColor.black
        return cell!
    }

    
    
}

