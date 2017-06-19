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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            //MARK:- Get Current location
            //MARK:- Get Current location
            
            self.CurrentLattitude = self.locationManager.location?.coordinate.latitude
            self.CurrentLongitude = self.locationManager.location?.coordinate.longitude
        })

        
        self.zoomToRegion()
        self.getMapsDetails()

        // Do any additional setup after loading the view.
    }
    func setInitParam()
    {
        self.view.addSubview(view_verifiedNumber)
        view_verifiedNumber.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        view_verifiedNumber.isHidden = true

        
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
        
        
        let params = [
            "latlng": "\(lat!),\(lan!)",
            "key": GoogleMapsAPIKey.GEOCODING_API_KEY
        ]
        print(params)
        
        
        
        
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
    

    @IBAction func Back(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    // MARK: - mapView Delegate

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //activityIndicator.isHidden = false
        //locationLabel.isHidden = true
        
        lblAddress.text = "Loading..."
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        
        
        let lat = mapView.camera.target.latitude
        let lon = mapView.camera.target.longitude
        
        
        let params = [
            "latlng": "\(lat),\(lon)",
            "key": GoogleMapsRestClient.GEOCODING_API_KEY
        ]
        
        GoogleMapsRestClient.geocodeAddress(params: params) { (response) in
            if response != nil {
                
                let responceArr = response!["results"]
                print(responceArr)
                
                if responceArr.count > 0
                {
                    var address_components = response!["results"][0]["formatted_address"].stringValue.components(separatedBy: ", ")
                    
                    var formattedAddress = "\(address_components[0])"
                    var counter = 1
                    for i in address_components{
                        if(counter < 3){
                            formattedAddress.append(", \(address_components[counter])")
                            counter = counter + 1
                        }else{
                            break
                        }
                    }
                    self.lblAddress.text = formattedAddress
                    self.DestinationLattitude = lat
                    self.DestinationLongitude = lon
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
    
    // MARK: - VERIFY NUMBER
    @IBAction func confirmPickup(_ sender: Any) {
        Constants.animatewithShow(show: true, with: view_verifiedNumber)
        
        subview_verifyNumber.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subview_verifyNumber.frame.size.height)
        subviewViewingFare.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewViewingFare.frame.size.height)
        subviewPayment.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewPayment.frame.size.height)

        
        self.popupWithAnimation(_subview: subview_verifyNumber, show: true)
    }

    @IBAction func EditNumber(_ sender: Any) {
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
