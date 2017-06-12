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

    
    //MARK:-  IBOutlets
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

        mapview.showsUserLocation = true

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
    
    //MARK:- Menu
    @IBAction func menuTapped(_ sender: Any)
    {
        Constants.app_delegate.openSideMenu()
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
        //let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    // MARK: - pickup
    @IBAction func pickupTapped(_ sender: Any) {
        /*
        let modalViewController = PickupTimeViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)*/
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickupTimeViewController") as! PickupTimeViewController
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)


    }
    
    // MARK: - CUSTOM PICKERs
    @IBAction func fromToTapped(_ sender: Any)
    {
        let move: AddLocationViewController = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        navigationController?.pushViewController(move, animated: true)

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
