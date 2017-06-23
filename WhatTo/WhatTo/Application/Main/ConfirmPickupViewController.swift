//
//  ConfirmPickupViewController.swift
//  WhatTo
//
//  Created by macmini on 14/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ConfirmPickupViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var btnConfirmPickup: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var btnPin: UIButton!
    
    
    var locationManager = CLLocationManager()
    
    var CurrentLattitude: Double?
    var CurrentLongitude: Double?
    
    var DestinationLattitude: Double?
    var DestinationLongitude: Double?
    
    //VERIFY NUMBER POPUP
    @IBOutlet var view_verifiedNumber: UIView!
    @IBOutlet weak var subview_verifyNumber: UIView!
    @IBOutlet weak var btnEditNumber: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    //VIEWING FARE POPUP
    @IBOutlet weak var subviewViewingFare: UIView!
    @IBOutlet weak var btnViewingFareCancel: UIButton!
    @IBOutlet weak var btnViewingFareContinue: UIButton!
    
    
    //PAYMENT
    @IBOutlet weak var subviewPayment: UIView!
    @IBOutlet weak var btnAddPayment: UIButton!
    
    
    //ConfirmPickup
    @IBOutlet weak var subviewConfirmPickup: UIView!
    @IBOutlet weak var lbl_ConfirmAddress: UILabel!
    
    
    //FIND DRIVER
    @IBOutlet var viewFindDriver: UIView!
    @IBOutlet weak var subviewFindYourRide: UIView!
    @IBOutlet weak var imgFindingYourRide: UIImageView!
    @IBOutlet weak var lblCircle: UILabel!
    

    //MARK:- VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitParam()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.CurrentLattitude = self.locationManager.location?.coordinate.latitude
            self.CurrentLongitude = self.locationManager.location?.coordinate.longitude
        })
        
        
        self.zoomToRegion()
        self.getMapsDetails()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverLocationFind), name: NSNotification.Name(rawValue: "FindNearestDriver"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.BackToMainScreen), name: NSNotification.Name(rawValue: "redirectMainScreen"), object: nil)

        
        super.viewWillAppear(animated) // No need for semicolon
    }

    func setInitParam()
    {
        self.view.addSubview(view_verifiedNumber)
        view_verifiedNumber.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        view_verifiedNumber.isHidden = true
        
        //FINDING DRIVER ANIMATION
        self.view.addSubview(viewFindDriver)
        viewFindDriver.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        viewFindDriver.isHidden = true
        
        let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:200, position:viewFindDriver.center)
        viewFindDriver.layer.insertSublayer(pulseEffect, below: lblCircle.layer)
        pulseEffect.radius = 200
        
        Constants.setBorderTo(subviewFindYourRide, withBorderWidth: 0, radiousView: 5.0, color: UIColor.clear)
        Constants.setBorderTo(imgFindingYourRide, withBorderWidth: 0, radiousView: Float(imgFindingYourRide.frame.size.height/2), color: UIColor.clear)
        Constants.setBorderTo(lblCircle, withBorderWidth: 0, radiousView: Float(lblCircle.frame.size.height/2), color: UIColor.clear)


        ///Verify Number
        Constants.shaodow(on: viewBox)
        Constants.setBorderTo(btnContinue, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        Constants.setBorderTo(btnEditNumber, withBorderWidth: 0.5, radiousView: 2, color: UIColor.darkGray)
        
        
        //ViewingFARE
        Constants.shaodow(on: subviewViewingFare)
        Constants.setBorderTo(btnViewingFareContinue, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        Constants.setBorderTo(btnViewingFareCancel, withBorderWidth: 0.5, radiousView: 2, color: UIColor.darkGray)
        
        
        //PAYMENT
        Constants.shaodow(on: subviewPayment)
        Constants.setBorderTo(btnAddPayment, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        
        
        //Address
        Constants.shaodow(on: subviewConfirmPickup)
        
    }
    
    func getMapsDetails()
    {
        let lat = CurrentLattitude
        let lan = CurrentLongitude
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat!, longitude: lan!))
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lan!, zoom: mapview.camera.zoom)
        mapview.camera = camera
        
        mapview.isMyLocationEnabled = true
        mapview.delegate = self
        mapview.settings.myLocationButton = true
        mapview.padding = UIEdgeInsetsMake(0, 0, 55, 0);
        
        
        let params = [
            "latlng": "\(lat!),\(lan!)",
            "key": GoogleMapsAPIKey.GEOCODING_API_KEY
        ]
        print(params)
        
        
        
        
    }
    
    func driverLocationFind()
    {
        self.perform(#selector(self.redirectRequestingScreen), with: nil, afterDelay: 5.0)
    }
    
    func BackToMainScreen()
    {
        /*
        for controller in self.navigationController!.viewControllers as Array
        {
            if controller.isKind(of: MainViewController.self)
            {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
         */
        
        Constants.animatewithShow(show: false, with: viewFindDriver)
    }
  
    func redirectRequestingScreen()
    {
        let move = self.storyboard?.instantiateViewController(withIdentifier: "RequestViewController") as! RequestViewController
        self.present(move, animated: true, completion: nil)
    }
    
    //MARK:- locationManager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            
            mapview.isMyLocationEnabled = true
            mapview.settings.myLocationButton = true
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 17.0)
        
        mapview?.animate(to: camera)
        
        CurrentLattitude = manager.location?.coordinate.latitude
        CurrentLongitude = manager.location?.coordinate.longitude
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
        /*
         if let location = locations.first {
         
         mapview.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         locationManager.stopUpdatingLocation()
         
         }*/
    }
    
    @objc func mapView(_ aMapView: MKMapView, didUpdate aUserLocation: MKUserLocation) {
        
        
    }
    
    
    //MARK:- Zoom to region
    func zoomToRegion() {
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        print(region)
        
        //mapview.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Back(_ sender: Any)
    {
        for controller in self.navigationController!.viewControllers as Array {
            
            if controller.isKind(of: MainViewController.self)
            {
                self.navigationController!.popToViewController(controller, animated: true)
                break
                
            }
        }
    }
    
    // MARK: - mapView Delegate
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        btnConfirmPickup.isHidden = true
        lblAddress.text = "Loading..."
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        btnConfirmPickup.isHidden = false
        
        let lat = mapView.camera.target.latitude
        let lon = mapView.camera.target.longitude
        
        
        let params = [
            "latlng": "\(lat),\(lon)",
            "key": GoogleMapsRestClient.GEOCODING_API_KEY
        ]
        
        GoogleMapsRestClient.geocodeAddress(params: params) { (response) in
            if response != nil {
                
                let responceArr = response!["results"]
                //print(responceArr)
                
                if responceArr.count > 0
                {
                    var address_components = response!["results"][0]["formatted_address"].stringValue.components(separatedBy: ", ")
                    
                    var formattedAddress = "\(address_components[0])"
                    var counter = 1
                    for i in address_components
                    {
                        if(counter < 3)
                        {
                            print(i)
                            
                            if counter == address_components.count
                            {
                                
                            }
                            else
                            {
                                formattedAddress.append(", \(address_components[counter])")
                                counter = counter + 1
                            }
                        }
                        else
                        {
                            break
                        }
                    }
                    self.lblAddress.text = formattedAddress
                    self.DestinationLattitude = lat
                    self.DestinationLongitude = lon
                }
                else
                {
                    self.lbl_ConfirmAddress.text = "Loading..."
                }
            }
        }
    }
    
    
    // MARK: - IBActions
    func popupWithAnimation(_subview: UIView, show:Bool)  {
        if show
        {
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - _subview.frame.size.height, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
        }
        else
        {
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
        }
    }
    
    
    
    // MARK: - SUBVIEW INIT FRAME
    func subviewINITFrame()
    {
        subview_verifyNumber.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subview_verifyNumber.frame.size.height)
        
        subviewViewingFare.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewViewingFare.frame.size.height)
        
        subviewPayment.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewPayment.frame.size.height)
        
        subviewConfirmPickup.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewConfirmPickup.frame.size.height)
    }
    
    // MARK: - VERIFY NUMBER
    @IBAction func confirmPickupFromPopup(_ sender: Any)
    {
        self.popupWithAnimation(_subview: subviewConfirmPickup, show: false)
        self.popupWithAnimation(_subview: subview_verifyNumber, show: true)
    }
    
    @IBAction func confirmPickup(_ sender: Any)
    {
        self.subviewINITFrame()
        
        //lbl_ConfirmAddress.text = String(format: "Confirm your pickup at %@", lblAddress.text!)
        let myString = String(format: "Confirm your pickup at %@", lblAddress.text!)
        
        let attString = NSMutableAttributedString(string: myString)
        
        attString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRangeFromString(myString))
        attString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: CGFloat(20)), range: NSRangeFromString(myString))
        
        let range: NSRange? = (myString as NSString).range(of: lblAddress.text!)
        attString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range:range!)
        lbl_ConfirmAddress.attributedText = attString

        
        
        Constants.animatewithShow(show: true, with: view_verifiedNumber)
        self.popupWithAnimation(_subview: subviewConfirmPickup, show: true)
    }
    
    @IBAction func EditNumber(_ sender: Any)
    {
        self.removeNumberVerificationPoup()
        self.popupWithAnimation(_subview: subview_verifyNumber, show: false)
    }
    
    @IBAction func Continue(_ sender: Any) {
        self.popupWithAnimation(_subview: subview_verifyNumber, show: false)
        self.popupWithAnimation(_subview: subviewViewingFare, show: true)
    }
    
    @IBAction func closeVerifyNumberView(_ sender: Any) {
        self.removeNumberVerificationPoup()
    }
    
    // MARK: - VIEWING FARE
    @IBAction func fareCancel(_ sender: Any)
    {
        self.removeNumberVerificationPoup()
        self.popupWithAnimation(_subview: subviewViewingFare, show: false)
    }
    @IBAction func fareContinue(_ sender: Any)
    {
        self.popupWithAnimation(_subview: subviewViewingFare, show: false)
        self.popupWithAnimation(_subview: subviewPayment, show: true)
    }
    
    
    // MARK: - PAYMENT
    @IBAction func AddPayment(_ sender: Any) {
        self.popupWithAnimation(_subview: subviewPayment, show: false)
        self.removeNumberVerificationPoup()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPamentViewController") as! AddPamentViewController
        self.present(vc, animated: true, completion: nil)
        
        
        Constants.animatewithShow(show: true, with: viewFindDriver)
        btnConfirmPickup.isHidden = true
        btnPin.isHidden = true
        
    }
    
    func removeNumberVerificationPoup()  {
        Constants.animatewithShow(show: false, with: view_verifiedNumber)
        //self.popupWithAnimation(_subview: subview_verifyNumber, show: false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
