//
//  HelpViewController.swift
//  WhatTo
//
//  Created by macmini on 27/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet weak var tbl: UITableView!
    
    var arrHelpList = NSMutableArray()

    var locationManager = CLLocationManager()
    var CurrentLattitude: Double?
    var CurrentLongitude: Double?

    override func viewDidLoad()
    {
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
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            if ((self.locationManager.location) != nil)
            {
                self.CurrentLattitude = self.locationManager.location?.coordinate.latitude
                self.CurrentLongitude = self.locationManager.location?.coordinate.longitude
            }
            else
            {
            }
        })

        
        let arrtemp1 = NSMutableArray()
        
        let arrtemp2 : NSMutableArray = ["Trip and fare review", "Account and Payment Options", "A Guide to Uber", "Signing Up", "More", "Accessibility"]
        
        
        let dict1:[String:Any] = ["titleHeader":"Your last trip", "titleFooter":"Report an issue with this trip", "arrList":arrtemp1]
        let dict2:[String:Any] = ["titleHeader":"Additional topic", "titleFooter":"", "arrList":arrtemp2]
        
        
        arrHelpList = [dict1,dict2]
        print(arrHelpList)

    }
    
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- locationManager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        CurrentLattitude = manager.location?.coordinate.latitude
        CurrentLongitude = manager.location?.coordinate.longitude
        
        self.locationManager.stopUpdatingLocation()
    }

    // MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrHelpList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            let TempDictCell = arrHelpList.object(at: section) as! NSDictionary
            let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray
            return TempArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        headerVw.backgroundColor = UIColor.clear
        
        let TempDictCell = arrHelpList.object(at: section) as! NSDictionary
        
        let lblusername = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(10), width: CGFloat(Constants.WIDTH), height: CGFloat(40)))
        lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:12)
        lblusername.textColor = Constants.DarkGray
        lblusername.text = TempDictCell.value(forKey: "titleHeader") as? String
        lblusername.backgroundColor = UIColor.clear
        headerVw.addSubview(lblusername)
                
        return headerVw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }

    
    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        headerVw.backgroundColor = UIColor.white
        
        let TempDictCell = arrHelpList.object(at: section) as! NSDictionary

        
        let lblusername = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:12)
        lblusername.textColor = Constants.DarkGray
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 50
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 175
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
            var cell: Cell_HelpHeader? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_HelpHeader)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_HelpHeader", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_HelpHeader)
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
            }
            
            //cell?.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat!, longitude: lan!))
            cell?.mapview.isMyLocationEnabled = true
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
            cell?.mapview.camera = camera
            
            return cell!
        }
        else
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: cell_list? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? cell_list)
            
            if cell == nil
            {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("cell_list", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? cell_list)
                cell?.backgroundColor = UIColor.white
                cell?.selectionStyle = .none
            }
            
            let TempDictCell = arrHelpList.object(at: indexPath.section) as! NSDictionary
            let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray

            cell?.lblTitle.frame = CGRect(x: 15, y: 0, width: Constants.WIDTH - 20, height: (cell?.lblTitle.frame.size.height)!)
            //cell?.lblTitle.text = TempArr.object(at: indexPath.row) as? String
            cell?.lblTitle.text = String.init(format: "%@", TempArr.object(at: indexPath.row) as! CVarArg)
            cell?.lblTitle.font = UIFont(name: "HelveticaNeue-Medium", size:12)
            cell?.lblTitle.textColor = UIColor.black

            cell?.lblSubtitle.text = ""

            cell?.accessoryType = .disclosureIndicator
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func footerTapped(sender: AnyObject)
    {
        print("you clicked on button \(sender.tag)")
    }

}
