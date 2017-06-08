//
//  MainViewController.swift
//  WhatTo
//
//  Created by macmini on 08/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate {

    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var subviewWhatTo: UIView!
    
    var locationManager: CLLocationManager!

    
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam() {
        
        Constants.shaodow(on: subviewWhatTo)
    }
    
    //MARK:- Zoom to region
    func zoomToRegion() {
        
        //let location = CLLocationCoordinate2D(latitude: 13.03297, longitude: 80.26518)
        
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate

        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        mapview.setRegion(region, animated: true)
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager = manager
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
