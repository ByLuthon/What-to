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
    
    @IBOutlet weak var imgUBERMOTO: UIImageView!
    @IBOutlet weak var imgUBERGO: UIImageView!
    @IBOutlet weak var imgUBERX: UIImageView!
    
    @IBOutlet weak var subvieeUBERMOTO: UIView!
    @IBOutlet weak var subviewUBERGO: UIView!
    @IBOutlet weak var subviewUBERX: UIView!
    
    @IBOutlet weak var mapview: GMSMapView!
    var locationManager = CLLocationManager()
    var pickupLatLng = CLLocationCoordinate2D()
    var destinationLatLng = CLLocationCoordinate2D()
    
    var distanceInMeters: Double! = 0
    var textDistance: String! = ""
    var myLocationMarker = GMSMarker()
    var destinationMarker = GMSMarker()
    var mapPolyline = GMSPolyline()
    
    
    var selectIndex: Int = -1
    
    @IBOutlet var viewDetails: UIView!
    @IBOutlet weak var subviewDetailsPopup: UIView!
    @IBOutlet weak var imgDetails: UIImageView!
    @IBOutlet weak var btnRequest: UIButton!
    
    
    //MARK:- DIDLOAD
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
        
        
        var bounds = GMSCoordinateBounds()
        for i in 0..<2 {
            if i == 0
            {
                let marker = GMSMarker()
                marker.position = pickupLatLng
                marker.map = self.mapview
                marker.icon = UIImage.init(named: "current-location.png")
                bounds = bounds.includingCoordinate(marker.position)
            }
            else
            {
                let marker = GMSMarker()
                marker.position = destinationLatLng
                marker.map = self.mapview
                marker.icon = UIImage.init(named: "current-location.png")
                bounds = bounds.includingCoordinate(marker.position)
            }
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 25)
        self.mapview.animate(with: update)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        Constants.setBorderTo(imgUBERMOTO, withBorderWidth: 1, radiousView: Float(imgUBERMOTO.frame.size.height/2), color: UIColor.lightGray)
        Constants.setBorderTo(imgUBERGO, withBorderWidth: 1, radiousView: Float(imgUBERGO.frame.size.height/2), color: UIColor.lightGray)
        Constants.setBorderTo(imgUBERX, withBorderWidth: 1, radiousView: Float(imgUBERX.frame.size.height/2), color: UIColor.lightGray)
        
        
        //DETAILS POPUP
        Constants.setBorderTo(imgDetails, withBorderWidth: 1, radiousView: Float(imgDetails.frame.size.height/2), color: UIColor.lightGray)
        self.view.addSubview(viewDetails)
        viewDetails.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        viewDetails.isHidden = true
        
        
        ////
        self.removeAnimation()
        for sub_view in subvieeUBERMOTO.subviews {
            if sub_view is UIImageView
            {
                let imageview : UIImageView = sub_view as! UIImageView
                imageview.image = UIImage(named: "example.jpg")
                //imageview.image = self.convertToGrayScale(image: UIImage.init(named: "example.jpg")!, scale: 10.0)
            }
            if sub_view is UILabel
            {
                let lbl : UILabel = sub_view as! UILabel
                lbl.textColor = UIColor.black
            }
        }
        
        btnRequest.setTitle("uberMOTO", for: .normal)
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
        
        /*
         let params = [
         "latlng": "\(lat!),\(lan!)",
         "key": GoogleMapsAPIKey.GEOCODING_API_KEY
         ]
         print(params)
         */
        
        
        //DRAW ROUTE
        let params = [
            "origin": "\(pickupLatLng.latitude),\(pickupLatLng.longitude)",
            "destination": "\(destinationLatLng.latitude),\(destinationLatLng.longitude)",
            "units": "metric",
            "key": GoogleMapsRestClient.DIRECTION_API_KEY
        ]
        print(params);
        self.drawRoute(params: params)
        
        /*
         var bounds = GMSCoordinateBounds()
         for i in 0..<2 {
         if i == 0
         {
         let marker = GMSMarker()
         marker.position = pickupLatLng
         marker.map = self.mapview
         bounds = bounds.includingCoordinate(marker.position)
         }
         else
         {
         let marker = GMSMarker()
         marker.position = destinationLatLng
         marker.map = self.mapview
         bounds = bounds.includingCoordinate(marker.position)
         }
         }
         let update = GMSCameraUpdate.fit(bounds, withPadding: 0)
         self.mapview.animate(with: update)*/
        
        
        
    }
    // MARK: - Draw Route
    func drawRoute(params: [String:String])
    {
        GoogleMapsRestClient.directions(params: params, complete: { (response) in
            if response != nil {
                //print(response)
                let encodedRoutePolyline = response!["routes"][0]["overview_polyline"]["points"].stringValue
                
                self.distanceInMeters = response!["routes"][0]["legs"][0]["distance"]["value"].doubleValue
                self.textDistance = response!["routes"][0]["legs"][0]["distance"]["text"].stringValue
                
                let path = GMSMutablePath(fromEncodedPath: encodedRoutePolyline)
                let polyline = GMSPolyline(path: path)
                
                polyline.strokeWidth = 3.0
                polyline.map = self.mapview
                self.mapPolyline = polyline
                self.mapPolyline.strokeColor = UIColor.black
            }
        })
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
        
        //mapview?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        //self.locationManager.stopUpdatingLocation()
        
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
    
    //MARK:- convertToGrayScale
    
    public func convertToGrayScale(image: UIImage, scale: Float) -> UIImage
    {
        let imgRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        //bitsPerComponent: Int(scale)
        let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
        
        context?.draw(image.cgImage!, in: imgRect)
        
        let imageRef = context!.makeImage()
        let newImg = UIImage(cgImage: imageRef!)
        
        return newImg
    }
    
    //MARK:- IBACTIONS
    @IBAction func pickupTimeTaed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickupTimeViewController") as! PickupTimeViewController
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func RequestTapped(_ sender: Any)
    {
        let move: ConfirmPickupViewController = storyboard?.instantiateViewController(withIdentifier: "ConfirmPickupViewController") as! ConfirmPickupViewController
        navigationController?.pushViewController(move, animated: true)
        
    }
    
    @IBAction func DoneDetails(_ sender: Any)
    {
        
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.4)
        subviewDetailsPopup.frame = CGRect(x: CGFloat(0), y: Constants.HEIGHT, width: Constants.WIDTH, height: subviewDetailsPopup.frame.size.height)
        
        Constants.animatewithShow(show: false, with: viewDetails)
        UIView.commitAnimations()
    }
    
    @IBAction func uberVehicalClicked(_ sender: Any)
    {
        let btn: UIButton = sender as! UIButton
        let selectTag = btn.tag
        
        if selectTag == selectIndex
        {
            //OPEN NEW SCREEN
            Constants.animatewithShow(show: true, with: viewDetails)
            
            subviewDetailsPopup.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subviewDetailsPopup.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            subviewDetailsPopup.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - subviewDetailsPopup.frame.size.height, width: CGFloat(Constants.WIDTH), height: subviewDetailsPopup.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
            
        }
        else
        {
            self.removeAnimation()
            selectIndex = selectTag
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1, animations: {() -> Void in
                
                if selectTag == 0
                {
                    self.btnRequest.setTitle("uberMOTO", for: .normal)
                    for sub_view in self.subvieeUBERMOTO.subviews {
                        
                        if sub_view is UIImageView
                        {
                            let imageview : UIImageView = sub_view as! UIImageView
                            imageview.image = UIImage.init(named: "example.jpg")
                        }
                        if sub_view is UILabel
                        {
                            let lbl : UILabel = sub_view as! UILabel
                            lbl.textColor = UIColor.black
                        }
                    }
                }
                else if selectTag == 1
                {
                    self.btnRequest.setTitle("uberGO", for: .normal)
                    for sub_view in self.subviewUBERGO.subviews {
                        
                        if sub_view is UIImageView
                        {
                            let imageview : UIImageView = sub_view as! UIImageView
                            imageview.image = UIImage.init(named: "example.jpg")
                        }
                        if sub_view is UILabel
                        {
                            let lbl : UILabel = sub_view as! UILabel
                            lbl.textColor = UIColor.black
                        }
                    }
                }
                else
                {
                    self.btnRequest.setTitle("uberX", for: .normal)
                    for sub_view in self.subviewUBERX.subviews {
                        
                        if sub_view is UIImageView
                        {
                            let imageview : UIImageView = sub_view as! UIImageView
                            imageview.image = UIImage.init(named: "example.jpg")
                        }
                        if sub_view is UILabel
                        {
                            let lbl : UILabel = sub_view as! UILabel
                            lbl.textColor = UIColor.black
                        }
                    }
                }
            })
        }
    }
    
    func animatedClickbutton(_selectbtn:UIButton)
    {
        
    }
    
    func removeAnimation() {
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.commitAnimations()
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            
            for sub_view in self.subvieeUBERMOTO.subviews {
                
                if sub_view is UIImageView
                {
                    let imageview : UIImageView = sub_view as! UIImageView
                    imageview.image = self.convertToGrayScale(image: imageview.image!, scale: 5.0)
                }
                if sub_view is UILabel
                {
                    let lbl : UILabel = sub_view as! UILabel
                    lbl.textColor = UIColor.gray
                }
            }
            
            for sub_view in self.subviewUBERGO.subviews {
                
                if sub_view is UIImageView
                {
                    let imageview : UIImageView = sub_view as! UIImageView
                    imageview.image = self.convertToGrayScale(image: imageview.image!, scale: 5.0)
                }
                if sub_view is UILabel
                {
                    let lbl : UILabel = sub_view as! UILabel
                    lbl.textColor = UIColor.gray
                }
            }
            
            for sub_view in self.subviewUBERX.subviews {
                
                if sub_view is UIImageView
                {
                    let imageview : UIImageView = sub_view as! UIImageView
                    imageview.image = self.convertToGrayScale(image: imageview.image!, scale: 5.0)
                }
                if sub_view is UILabel
                {
                    let lbl : UILabel = sub_view as! UILabel
                    lbl.textColor = UIColor.gray
                }
            }
            
        })
    }
    
    
    
    
    @IBAction func Back(_ sender: Any)
    {
        //self.navigationController?.pop(animated: true)
        
        for controller in self.navigationController!.viewControllers as Array {
            
            if controller.isKind(of: MainViewController.self)
            {
                self.navigationController!.popToViewController(controller, animated: true)
                break
                
            }
        }
    }
    
}
