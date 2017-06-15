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

    @IBOutlet weak var subview_work: UIView!
    @IBOutlet weak var subview_workimage: UIView!
    
    @IBOutlet weak var subview_home: UIView!
    @IBOutlet weak var subview_homeimage: UIView!
    
    //MARK:-  IBOutlets
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var subviewWhatTo: UIView!
    
    @IBOutlet weak var viewMessage: UIView!
    
    var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

    override func viewWillAppear(_ animated: Bool) {
        self.setInitParam()
        super.viewWillAppear(animated) // No need for semicolon
        
        
        //self.popupWithAnimation(_subview: subviewWhatTo, show: true, animationTime: 0.8)
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.8)
        subviewWhatTo.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: 75, width: subviewWhatTo.frame.size.width, height: subviewWhatTo.frame.size.height)
        UIView.commitAnimations()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
        })
        
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(1.0)
        viewMessage.frame = CGRect(x:viewMessage.frame.origin.x, y: Constants.HEIGHT - viewMessage.frame.size.height, width: viewMessage.frame.size.width, height: viewMessage.frame.size.height)
        UIView.commitAnimations()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam() {
        
        subviewWhatTo.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: -subviewWhatTo.frame.size.height, width: subviewWhatTo.frame.size.width, height: subviewWhatTo.frame.size.height)
       
        viewMessage.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: Constants.HEIGHT, width: viewMessage.frame.size.width, height: viewMessage.frame.size.height)

        Constants.shaodow(on: subviewWhatTo)
        
        Constants.setBorderTo(subview_workimage, withBorderWidth: 0, radiousView: Float(subview_workimage.frame.size.height/2), color: UIColor.darkGray)
        Constants.setBorderTo(subview_homeimage, withBorderWidth: 0, radiousView: Float(subview_homeimage.frame.size.height/2), color: UIColor.darkGray)

        subview_home.isHidden = false
        subview_work.isHidden = false

        self.setBothviewCenter()
        
        if Constants.app_delegate.HomeDict == nil
        {
            if Constants.app_delegate.WorkDict == nil
            {
                subview_home.isHidden = true
                subview_work.isHidden = true
            }
            else
            {
                self.setSingleViewToCenter(subview_work)
                subview_home.isHidden = true
                subview_work.isHidden = false
            }
        }
        else
        {
            if Constants.app_delegate.WorkDict == nil
            {
                self.setSingleViewToCenter(subview_home)

                subview_home.isHidden = false
                subview_work.isHidden = true
            }
            else
            {
                subview_home.isHidden = false
                subview_work.isHidden = false
            }
        }
    }
    
    func setBothviewCenter(){
        
        let x = Constants.WIDTH
        let y = subview_home.frame.size.width + subview_work.frame.size.width
        
        let space = (x - y) / 3
        
        subview_work.frame = CGRect(x: space, y: Constants.HEIGHT - 150, width: subview_work.frame.size.width, height: subview_work.frame.size.height)
        
        subview_home.frame = CGRect(x: (space + subview_work.frame.size.width + space), y: Constants.HEIGHT - 150, width: subview_work.frame.size.width, height: subview_work.frame.size.height)

    }
    
    func setSingleViewToCenter(_ view: UIView)
    {
        let space = (Constants.WIDTH - view.frame.size.width) / 2

        view.frame = CGRect(x: space, y: Constants.HEIGHT - 150, width: view.frame.size.width, height: view.frame.size.height)
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
    
    
    
    func popupWithAnimation(_subview: UIView, show:Bool, animationTime:Float)  {
        
        if show
        {
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(TimeInterval(animationTime))
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - _subview.frame.size.height, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
        }
        else
        {
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(TimeInterval(animationTime))
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
        }
    }

    // MARK: - IBAction
    @IBAction func fromToTapped(_ sender: Any)
    {
        let move: AddLocationViewController = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        navigationController?.pushViewController(move, animated: true)

    }

    
    @IBAction func homeTapped(_ sender: Any)
    {
        let move: RouteDrawViewController = storyboard?.instantiateViewController(withIdentifier: "RouteDrawViewController") as! RouteDrawViewController
        move.pickupLatLng = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!,  (locationManager.location?.coordinate.longitude)!)
        move.destinationLatLng = CLLocationCoordinate2DMake(Constants.app_delegate.HomeDict.value(forKey: "latitude") as! CLLocationDegrees, Constants.app_delegate.HomeDict.value(forKey: "longitude") as! CLLocationDegrees)
        navigationController?.pushViewController(move, animated: true)
    }
   
    @IBAction func workTapped(_ sender: Any)
    {
        let move: RouteDrawViewController = storyboard?.instantiateViewController(withIdentifier: "RouteDrawViewController") as! RouteDrawViewController
        move.pickupLatLng = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!,  (locationManager.location?.coordinate.longitude)!)
        move.destinationLatLng = CLLocationCoordinate2DMake(Constants.app_delegate.WorkDict.value(forKey: "latitude") as! CLLocationDegrees, Constants.app_delegate.WorkDict.value(forKey: "longitude") as! CLLocationDegrees)
        navigationController?.pushViewController(move, animated: true)
    }
 
    
    // MARK: - EditProfile

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
