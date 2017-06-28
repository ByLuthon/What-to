//
//  SettingViewController.swift
//  WhatTo
//
//  Created by macmini on 27/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var arrSettings = NSMutableArray()
    @IBOutlet weak var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitParam()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam()
    {
        let BlankArr = NSMutableArray()
        
        //ProfileSection
        let dictProfile:[String:Any] = ["titleHeader":"", "titleFooter":"", "arrList":BlankArr]
        
        
        //Favourite Section
        let dictHome:[String:String] = ["title":"Add Home", "icon":"home.png"]
        let dictWork:[String:String] = ["title":"Add Work", "icon":"briefcase.png"]
        let dictPlaces:[String:String] = ["title":"More Saved Places", "icon":""]
        
        let arrtemp : NSMutableArray = [dictHome, dictWork, dictPlaces]
        let dictFavorites:[String:Any] = ["titleHeader":"Favorites", "titleFooter":"More Saved Places", "arrList":arrtemp]
        
        
        //Events
        let dictEvent:[String:Any] = ["titleHeader":"Events", "titleFooter":"", "arrList":BlankArr]
        
        
        //Profile
        let dictBussinessProfile:[String:Any] = ["titleHeader":"Profiles", "titleFooter":"", "arrList":BlankArr]
        
        
        //Privacy
        let dictPrivacy:[String:Any] = ["titleHeader":"", "titleFooter":"", "arrList":BlankArr]
        
        
        //SignOut
        let dictSignOut:[String:Any] = ["titleHeader":"", "titleFooter":"", "arrList":BlankArr]
        
        
        
        
        //FILL UP ARRAY
        arrSettings = [dictProfile, dictFavorites, dictEvent, dictBussinessProfile,dictPrivacy, dictSignOut]
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1
        {
            let TempDictCell = arrSettings.object(at: section) as! NSDictionary
            let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray
            return TempArr.count
        }
        else
        {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        headerVw.backgroundColor = UIColor.clear
        
        let TempDictCell = arrSettings.object(at: section) as! NSDictionary
        
        let lblusername = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(20), width: CGFloat(Constants.WIDTH), height: CGFloat(30)))
        lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:12)
        lblusername.textColor = Constants.LightGray
        lblusername.text = TempDictCell.value(forKey: "titleHeader") as? String
        lblusername.backgroundColor = UIColor.clear
        headerVw.addSubview(lblusername)
        
        return headerVw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    /*
    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if section == 1
        {
            
            let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(40)))
            headerVw.backgroundColor = UIColor.white
            
            let TempDictCell = arrSettings.object(at: section) as! NSDictionary
            
            
            let lblusername = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(40)))
            lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:12)
            lblusername.textColor = Constants.hexStringToUIColor(hex: "#53A6C5")
            lblusername.text = TempDictCell.value(forKey: "titleFooter") as? String
            lblusername.backgroundColor = UIColor.clear
            headerVw.addSubview(lblusername)
            
            
            let button:UIButton = UIButton(frame: lblusername.frame)
            button.setTitle("", for: UIControlState.normal)
            button.tag = section
            button.addTarget(self, action:#selector(self.footerTapped), for: .touchUpInside)
            headerVw.addSubview(button)
            
            
            return headerVw
        }
        else
        {
            let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(
            )))
            headerVw.backgroundColor = UIColor.clear
            return headerVw
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            return 40
        }
        else
        {
            return CGFloat.leastNormalMagnitude
        }
    }
    */
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 75
        }
        else if indexPath.section == 1
        {
            return 50
        }
        else if indexPath.section == 2
        {
            return 50
        }
        else if indexPath.section == 3
        {
            return 50
        }
        else if indexPath.section == 4
        {
            return 40
        }
        else if indexPath.section == 5
        {
            return 40
        }
        else
        {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_settingProfile? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_settingProfile)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_settingProfile", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_settingProfile)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
        else if indexPath.section == 1
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_setLocation? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_setLocation)
            
            if cell == nil {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_setLocation", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_setLocation)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            
            let TempDictCell = arrSettings.object(at: indexPath.section) as! NSDictionary
            let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray
            let dictCell = TempArr.object(at: indexPath.row) as! NSDictionary
            
            if indexPath.row == 0
            {
                if Constants.app_delegate.HomeDict == nil
                {
                    cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
                    
                    cell?.subview_Double.isHidden = true
                    cell?.subview_single.isHidden = false
                }
                else
                {
                    cell?.subview_Double.isHidden = false
                    cell?.subview_single.isHidden = true
                    
                    cell?.lblPlaceTitle.text = "Home"
                    cell?.lblPlaceAddress.text = Constants.app_delegate.HomeDict.value(forKey: "place_address") as? String
                }
                cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
                
            }
            else if indexPath.row == 1
            {
                if Constants.app_delegate.WorkDict == nil
                {
                    cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
                    
                    cell?.subview_Double.isHidden = true
                    cell?.subview_single.isHidden = false
                }
                else
                {
                    cell?.subview_Double.isHidden = false
                    cell?.subview_single.isHidden = true
                    
                    cell?.lblPlaceTitle.text = "Work"
                    cell?.lblPlaceAddress.text = Constants.app_delegate.WorkDict.value(forKey: "place_address") as? String
                }
                cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
            }
            else
            {
                cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
                cell?.lblTitle.textColor = Constants.hexStringToUIColor(hex: "#53A6C5")

                cell?.subview_Double.isHidden = true
                cell?.subview_single.isHidden = false

            }
            
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
        else if indexPath.section == 2
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_CalendarEvent? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_CalendarEvent)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_CalendarEvent", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_CalendarEvent)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            cell?.accessoryType = .disclosureIndicator

            return cell!
        }
        else if indexPath.section == 3
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_SettingBussinessProfile? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_SettingBussinessProfile)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_SettingBussinessProfile", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_SettingBussinessProfile)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            cell?.accessoryType = .disclosureIndicator

            return cell!
        }
        else if indexPath.section == 4
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_SettingPrivacyPolicy? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_SettingPrivacyPolicy)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_SettingPrivacyPolicy", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_SettingPrivacyPolicy)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
        else
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_SettingSignout? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_SettingSignout)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_SettingSignout", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_SettingSignout)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    // MARK: - IBAction Delegate
    
    func footerTapped(sender: AnyObject)
    {
        print("you clicked on button \(sender.tag)")
    }
    
}
