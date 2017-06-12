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


class PinLocationViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate{

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

    var distanceInMeters: Double! = 0
    var textDistance: String! = ""

    var DestinationLattitude: Double?
    var DestinationLongitude: Double?
    
    var CurrentLattitude: Double?
    var CurrentLongitude: Double?


    var myLocationMarker = GMSMarker()
    var destinationMarker = GMSMarker()
    var mapPolyline = GMSPolyline()

    //MARK:- viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()

        //MARK:- Get Current location
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        CurrentLattitude = locationManager.location?.coordinate.latitude
        CurrentLongitude = locationManager.location?.coordinate.longitude
        
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
        
        CurrentLattitude = locationManager.location?.coordinate.latitude
        CurrentLongitude = locationManager.location?.coordinate.longitude

        
        let camera = GMSCameraPosition.camera(withLatitude: CurrentLattitude!, longitude: CurrentLongitude!, zoom: mapview.camera.zoom)
        mapview.camera = camera

    }
    
    // MARK: - MAPVIE DELEGATE

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //activityIndicator.isHidden = false
        //locationLabel.isHidden = true
        
        self.mapPolyline.map = nil

    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        //activityIndicator.isHidden = true
        //locationLabel.isHidden = false
        
        let lat = mapView.camera.target.latitude
        let lon = mapView.camera.target.longitude
        
        if self.mapPolyline.map != nil {
            self.mapPolyline.map = nil
        }

        let params = [
            "latlng": "\(lat),\(lon)",
            "key": GoogleMapsRestClient.GEOCODING_API_KEY
        ]
        
        GoogleMapsRestClient.geocodeAddress(params: params) { (response) in
            if response != nil {
                
                var responceArr = response!["results"]
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
                    self.txtPinLocation.text = formattedAddress
                    
                    self.DestinationLattitude = lat
                    self.DestinationLongitude = lon
                    

                    let Current_lat = String(format: "%f", (self.locationManager.location?.coordinate.latitude)!)
                    let Current_lon = String(format: "%f", (self.locationManager.location?.coordinate.longitude)!)

                    let params = [
                        "origin": "\(Current_lat),\(Current_lon)",
                        "destination": "\(lat),\(lon)",
                        "units": "metric",
                        "key": GoogleMapsRestClient.DIRECTION_API_KEY
                    ]
                    
                    print(params);
                    self.drawRoute(params: params)

                }
                

                /*
                self.location["address"] = formattedAddress
                self.location["latitude"] = "\(lat)"
                self.location["longitude"] = "\(lon)"*/
            }
        }
    }

    // MARK: - Draw Route
    func drawRoute(params: [String:String])
    {
        GoogleMapsRestClient.directions(params: params, complete: { (response) in
            if response != nil {
                print(response)
                let encodedRoutePolyline = response!["routes"][0]["overview_polyline"]["points"].stringValue
                
                self.distanceInMeters = response!["routes"][0]["legs"][0]["distance"]["value"].doubleValue
                self.textDistance = response!["routes"][0]["legs"][0]["distance"]["text"].stringValue
                
                let path = GMSMutablePath(fromEncodedPath: encodedRoutePolyline)
                let polyline = GMSPolyline(path: path)
                
                polyline.strokeWidth = 3.0
                polyline.map = self.mapview
                self.mapPolyline = polyline
            }
        })
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