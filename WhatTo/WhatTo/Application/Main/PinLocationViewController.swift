//
//  PinLocationViewController.swift
//  WhatTo
//
//  Created by macmini on 09/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces


class PinLocationViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{

    //MARK:-  IBOutlets
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var subviewCurrentLocation: UIView!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var subviewPinLocation: UIView!
    @IBOutlet weak var txtPinLocation: UITextField!
    @IBOutlet weak var lblLocationDots: UILabel!
   
    @IBOutlet weak var mapview: GMSMapView!
    
    var myLocationResultsViewController: GMSAutocompleteResultsViewController?
    var destinationResultsViewController: GMSAutocompleteResultsViewController?

    var locationManager = CLLocationManager()
    var myLocationLatLng = CLLocationCoordinate2D()
    var destinationLatLng = CLLocationCoordinate2D()

    var lattitude: Double?
    var longitude: Double?

    var myLocationMarker = GMSMarker()
    var destinationMarker = GMSMarker()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()

        //MARK:- Get Current location
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        lattitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
        
        self.zoomToRegion()
        self.getMapsDetails()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam()
    {
        Constants.shaodow(on: viewHeader)
        Constants.setBorderTo(subviewCurrentLocation, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        Constants.setBorderTo(subviewPinLocation, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        
        Constants.setBorderTo(lblLocationDots, withBorderWidth: 0, radiousView: Float(lblLocationDots.frame.size.height/2), color: UIColor.clear)

    }
    
    func getMapsDetails()
    {
        let lat = lattitude
        let lan = longitude
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat!, longitude: lan!))
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lan!, zoom: mapview.camera.zoom)
        mapview.camera = camera
        
        mapview.isMyLocationEnabled = true

        
        let params = [
            "latlng": "\(lat!),\(lan!)",
            "key": GoogleMapsAPIKey.GEOCODING_API_KEY
        ]
        print(params)
        

        
        
    }

    //MARK:- locationManager

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapview.isMyLocationEnabled = true
            mapview.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapview.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
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
    

    @IBAction func Backtapped(_ sender: Any)
    {
        navigationController?.pop(animated: true)
    }
    @IBAction func DoneTapped(_ sender: Any) {
    }
    @IBAction func currentLocationTapped(_ sender: Any)
    {
        /*
        lattitude = self.mapview.camera.target.latitude
        longitude = self.mapview.camera.target.longitude

        let params = [
            "latlng": "\(String(describing: lattitude)),\(String(describing: longitude))",
            "key": GoogleMapsAPIKey.GEOCODING_API_KEY
        ]
        print(params)

        mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!))*/
        
        self.getMapsDetails()

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
