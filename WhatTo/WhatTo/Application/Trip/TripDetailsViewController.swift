//
//  TripDetailsViewController.swift
//  WhatTo
//
//  Created by macmini on 27/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class TripDetailsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate {

    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet var viewTableHeader: UIView!
    
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var imgDriver: UIImageView!
    
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var lblReceipt: UILabel!
    @IBOutlet weak var lblUnderLine: UILabel!
    
    var locationManager = CLLocationManager()
    var CurrentLattitude: Double?
    var CurrentLongitude: Double?

    
    var selectedTab: Int = 0
    
    var arrHelp = NSMutableArray()
    var arrReceipt = NSMutableArray()

    
    // MARK: - viewDidLoad

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tbl.tableHeaderView = viewTableHeader
        
        self.mapDetails()
        self.setInitParam()
        

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

        // Do any additional setup after loading the view.
    }

    func mapDetails()
    {
        let lat = self.locationManager.location?.coordinate.latitude
        let lan = self.locationManager.location?.coordinate.longitude
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat!, longitude: lan!))
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lan!, zoom: 15.0)
        mapview.camera = camera
        mapview?.animate(to: camera)
        
        
        mapview.isMyLocationEnabled = true
        mapview.delegate = self
    }
    
    func setInitParam()
    {
        Constants.setBorderTo(lblCircle, withBorderWidth: 0, radiousView: Float(lblCircle.frame.size.height / 2) , color: UIColor.clear)
        Constants.setBorderTo(imgDriver, withBorderWidth: 1, radiousView: Float(imgDriver.frame.size.height / 2) , color: UIColor.gray)
        
        
        arrHelp = ["I was incorrectly charged a cancellation fee","I was involved in an accident", "I loas an item", "I would like a refunf" , "My Driver was unprofessional", "My Vehical wasn't what i expected", "I can't request a ride", "I had a different issue"]
        
        let dictVehicalName:[String:String] = ["title":"UberX", "price":""]
        let dictSubTotal:[String:String] = ["title":"Subtotal", "price":"₹0.0"]
        let dicttotal:[String:String] = ["title":"Total", "price":"₹0.0"]
        let dictCash:[String:String] = ["title":"Cash", "price":"₹0.0"]
       
        
        arrReceipt = [dictVehicalName ,dictSubTotal, dicttotal, dictCash]

        self.setLineFrameUnderMenu(lblHelp)
        selectedTab = 0
        tbl.reloadData()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UnderLine Button
    func setLineFrameUnderMenu(_ lbl: UILabel)
    {
        resetButtontitleColor()
        lbl.textColor = UIColor.darkGray
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations:
            {() -> Void in
            self.lblUnderLine.frame = CGRect(x: CGFloat((lbl.frame.origin.x)), y: CGFloat(self.lblUnderLine.frame.origin.y), width: CGFloat((lbl.frame.size.width)), height: CGFloat(2.0))
        },
                       completion: {(_ finished: Bool) -> Void in
        })

    }

    @IBAction func tabSelected(_ sender: Any)
    {
        let btn: UIButton? = (sender as? UIButton)
        var indx: Int = 0
        
        indx = Int((btn?.tag)!)
        
        switch indx
        {
        case 1:
            
            self.setLineFrameUnderMenu(lblHelp)
            selectedTab = 0
            tbl.reloadData()
            
        case 2:
            
            self.setLineFrameUnderMenu(lblReceipt)
            selectedTab = 1
            tbl.reloadData()
            
        default:
            break
        }
    }
    func resetButtontitleColor()
    {
        lblHelp.textColor = UIColor.gray
        lblReceipt.textColor = UIColor.gray
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

    // MARK: - TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedTab == 0
        {
            return arrHelp.count
        }
        else
        {
            return arrReceipt.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
        
        if selectedTab == 0
        {
            cell?.lblTitle.text = arrHelp.object(at: indexPath.row) as? String
            cell?.lblSubtitle.text = ""
        }
        else
        {
            let dictCell = arrReceipt.object(at: indexPath.row) as! NSDictionary

            cell?.lblTitle.text = dictCell.object(forKey: "title") as? String
            cell?.lblSubtitle.text = dictCell.object(forKey: "price") as? String
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }

}
