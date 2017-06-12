//
//  RouteDrawViewController.swift
//  WhatTo
//
//  Created by macmini on 12/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class RouteDrawViewController: UIViewController ,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet weak var subview_mainBox: UIView!
    
    @IBOutlet weak var btnPickupTime: UIButton!
    
    
    
    @IBOutlet weak var mapview: GMSMapView!
    var locationManager = CLLocationManager()
    var myLocationLatLng = CLLocationCoordinate2D()
    var destinationLatLng = CLLocationCoordinate2D()
    var mapPolyline = GMSPolyline()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()
        
        //MARK:- Get Current location
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        self.zoomToRegion()
        self.getMapsDetails()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Back(_ sender: Any)
    {
        self.navigationController?.pop(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setInitParam()
    {
        Constants.shaodow(on: subview_mainBox)
        Constants.setBorderTo(btnPickupTime, withBorderWidth: 1, radiousView: 2, color: UIColor.lightGray)
        
    }
    
    func getMapsDetails()
    {
        let lat = locationManager.location?.coordinate.latitude
        let lan = locationManager.location?.coordinate.longitude
        
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
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    

    
    
    //MARK:- Zoom to region
    func zoomToRegion()
    {
        /*
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        print(region)*/
        
        //mapview.setRegion(region, animated: true)
    }
    

}
