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
import CoreLocation
import GoogleMaps
import GooglePlaces
import CZPicker


class MainViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate, UITableViewDelegate,UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, ARCarMovementDelegate {
    
    @IBOutlet weak var subview_work: UIView!
    @IBOutlet weak var subview_workimage: UIView!
    
    @IBOutlet weak var subview_home: UIView!
    @IBOutlet weak var subview_homeimage: UIView!
    
    
    //MARK:-  Class Reference
    var czPickerView: CZPickerView?
    
    //MARK:-  IBOutlets
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var subviewWhatTo: UIView!
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessageBG: UILabel!

    
    var locationManager: CLLocationManager!
    var location : CLLocationCoordinate2D!
    
    var isMessageHidden = Bool()
    var isMessagescreenOpen = Bool()
    var isLocationTapped = Bool()
    var isopenLocationScreen = Bool()
    var isfindLocation = Bool()
    var isCurrentLocationTextfirldEditing = Bool()

    
    //Location Screen
    var arrLocation: NSMutableArray!
    var arrFromvalues: NSMutableArray!
    var arrLocationList = NSMutableArray()
    
    @IBOutlet var viewLocation: UIView!
    @IBOutlet weak var viewLocationHeader: UIView!
    @IBOutlet weak var viewLocationBottom: UIView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var txtWhatTo: UITextField!
    
    
    //Autocompate Textfield
    @IBOutlet weak var txtCurrentLocation: AutoCompleteTextField!
    @IBOutlet weak var txtWhereTo: AutoCompleteTextField!
    var responseData:NSMutableData?
    var selectedPointAnnotation:MKPointAnnotation?
    var dataTask:URLSessionDataTask?
    
    
    //Car Animation
    var driverMarker: GMSMarker!
    var moveMent: ARCarMovement!
    var coordinateArr = NSArray()
    var oldCoordinate: CLLocationCoordinate2D!
    var timer: Timer! = nil
    var counter: NSInteger!


    
    
    //MessageViewAnimation
    // Container view to display video player modal view controller when minimized
    @IBOutlet weak var thumbnailVideoContainerView: UIView!
    @IBOutlet weak var subview_thumbnail: UIView!
    // Create an interactive transitioning delegate
    let customTransitioningDelegate: InteractiveTransitioningDelegate = InteractiveTransitioningDelegate()
    
    //VideoPlayerModalViewController
    lazy var videoPlayerViewController: messageViewController = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "messageViewController") as! messageViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.customTransitioningDelegate
        // Pan gesture recognizer feedback from VideoPlayerModalViewController
        vc.handlePan = {(panGestureRecozgnizer) in
            
            let translatedPoint = panGestureRecozgnizer.translation(in: self.view)
            
            if (panGestureRecozgnizer.state == .began) {
                
                
                self.customTransitioningDelegate.beginDismissing(viewController: vc)
                self.lastVideoPlayerOriginY = vc.view.frame.origin.y
                
            } else if (panGestureRecozgnizer.state == .changed) {
                let ratio = max(min(((self.lastVideoPlayerOriginY + translatedPoint.y) / self.thumbnailVideoContainerView.frame.minY), 1), 0)
                
                self.hideBottmView(isShow: false)
                //print(ratio)
                self.rotateButton(radiousbtn: ratio*2)
                
                // Store lastPanRatio for next callback
                self.lastPanRatio = ratio
                
                // Update percentage of interactive transition
                self.customTransitioningDelegate.update(self.lastPanRatio)
            } else if (panGestureRecozgnizer.state == .ended) {
                // If pan ratio exceeds the threshold then transition is completed, otherwise cancel dismissal and present the view controller again
                let completed = (self.lastPanRatio > self.panRatioThreshold) || (self.lastPanRatio < -self.panRatioThreshold)
                
                //print(completed)
                if completed
                {
                    self.hideBottmView(isShow: true)
                }
                else
                {
                    self.hideBottmView(isShow: false)
                    self.rotateButton(radiousbtn: 0.0)
                }
                self.isMessagescreenOpen = completed
                self.customTransitioningDelegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
            }
        }
        return vc
    }()
    
    let panRatioThreshold: CGFloat = 0.3
    var lastPanRatio: CGFloat = 0.0
    var lastVideoPlayerOriginY: CGFloat = 0.0
    var videoPlayerViewControllerInitialFrame: CGRect?
    
    
    //MARK:- VIEWDIDLOAD - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(viewLocation)
        viewLocation.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        viewLocation.isHidden = true
        
        isMessageHidden = false
        
        locationManager = CLLocationManager()
        isLocationTapped = false
        
        self.setMessageViewAnimation()
        self.zoomToRegion()
        self.setCarAnimation()
        
        configureTextField()
        handleTextFieldInterfaces()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setInitParam()
        
        if !isMessagescreenOpen
        {
            self.popupAnimation()
        }
        
        tbl.reloadData()
        
        self.view.bringSubview(toFront: subview_home)
        self.view.bringSubview(toFront: subview_work)

        super.viewWillAppear(animated) // No need for semicolon
    }
    
    func setInitParam()
    {
        //Border and shadow
        Constants.shaodow(on: subviewWhatTo)
        Constants.setBorderTo(lblMessageBG, withBorderWidth: 0, radiousView: 5.0, color: UIColor.clear)
        Constants.setBorderTo(subview_workimage, withBorderWidth: 0, radiousView: Float(subview_workimage.frame.size.height/2), color: UIColor.darkGray)
        Constants.setBorderTo(subview_homeimage, withBorderWidth: 0, radiousView: Float(subview_homeimage.frame.size.height/2), color: UIColor.darkGray)
        Constants.setBorderTo(viewMessage, withBorderWidth: 0, radiousView: 5, color: UIColor.clear)

        
        //Set Frame
        viewMessage.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: Constants.HEIGHT, width: viewMessage.frame.size.width, height: viewMessage.frame.size.height)

        
        
        //Location
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            
            //print("LOCATION HERE......")
            //print(self.locationManager.location)
            if ((self.locationManager.location) != nil){
                self.location = self.locationManager.location!.coordinate
            }
            else
            {
                
            }
        })
        
        btnCurrentLocation.isHidden = true
        self.view.bringSubview(toFront: btnCurrentLocation)

        
        
        
        // HOME AND WORK BOTTOM VIEW
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
        
        
        
        //LOCATION POPUP
        let dictHome:[String:String] = ["title":"Add Home", "icon":"home.png"]
        let dictWork:[String:String] = ["title":"Add Work", "icon":"briefcase.png"]
        let dictPinLocation:[String:String] = ["title":"Set pin location", "icon":"pinLocation.png"]
        let dictSkipDestination:[String:String] = ["title":"Skip destination", "icon":"forword.png"]
        
        arrLocation = [dictHome,dictWork, dictPinLocation, dictSkipDestination]
        tbl.reloadData()
        tbl.tableFooterView = UIView()
        
        arrFromvalues = ["Meet the girlfriend","Hangout with friends","Traveling","Restaurant","Shopping"]
        
        txtCurrentLocation.attributedPlaceholder = NSAttributedString(string: "Current Location", attributes: [NSForegroundColorAttributeName: Constants.hexStringToUIColor(hex: "#3696C1")])
        txtWhereTo.attributedPlaceholder = NSAttributedString(string: "Where to ?", attributes: [NSForegroundColorAttributeName: Constants.hexStringToUIColor(hex: "#686868")])
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
    
    func popupAnimation()
    {
        subviewWhatTo.alpha = 0.0
        subviewWhatTo.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: 40, width: subviewWhatTo.frame.size.width, height: subviewWhatTo.frame.size.height)
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.8)
        subviewWhatTo.frame = CGRect(x:subviewWhatTo.frame.origin.x, y: 100, width: subviewWhatTo.frame.size.width, height: subviewWhatTo.frame.size.height)
        subviewWhatTo.alpha = 1.0
        UIView.commitAnimations()
        
        if isMessageHidden
        {
            isMessageHidden = false
            viewMessage.frame = CGRect(x:viewMessage.frame.origin.x, y: Constants.HEIGHT - 55, width: viewMessage.frame.size.width, height: 55)
            //self.view.bringSubview(toFront: viewMessage)
            //videoPlayerViewController.subview_popup.isHidden = true
            videoPlayerViewController.lblMessage.isHidden = true
            
        }
        else
        {
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(1.0)
            viewMessage.frame = CGRect(x:viewMessage.frame.origin.x, y: Constants.HEIGHT - viewMessage.frame.size.height, width: viewMessage.frame.size.width, height: viewMessage.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CAR MOVEMENT ANIMATION
    func setCarAnimation()
    {
        moveMent = ARCarMovement()
        moveMent.delegate = self
        

        do {
            if let file = Bundle.main.url(forResource: "coordinates", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    coordinateArr = NSArray(array: object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        //set old coordinate
        //
        oldCoordinate = CLLocationCoordinate2DMake(40.7416627, -74.0049708)
        
        // Creates a marker in the center of the map.
        driverMarker = GMSMarker()
        driverMarker.position = oldCoordinate
        driverMarker.icon = UIImage(named: "NewCar.png")
        driverMarker.map = self.mapview
        
        //set counter value 0
        //
        counter = 0
        
        //start the timer, change the interval based on your requirement
        //
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timerTriggered), userInfo: nil, repeats: true)
    }

    func timerTriggered()
    {
        if counter < coordinateArr.count
        {
            
            let dict = coordinateArr[counter] as? Dictionary<String,AnyObject>
            
            let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(dict!["lat"] as! Float), CLLocationDegrees(dict!["long"] as! Float))
            /**
             *  You need to pass the created/updating marker, old & new coordinate, mapView and bearing value from driver
             *  device/backend to turn properly. Here coordinates json files is used without new bearing value. So that
             *  bearing won't work as expected.
             */
            moveMent.arCarMovement(driverMarker, withOldCoordinate: oldCoordinate, andNewCoordinate: newCoordinate, inMapview: mapview, withBearing: 0)
            oldCoordinate = newCoordinate
            counter = counter + 1
            //increase the value to get all index position from array
        }
        else {
            timer.invalidate()
            timer = nil
        }
    }
    
    func arCarMovement(_ movedMarker: GMSMarker)
    {
        driverMarker = movedMarker
        driverMarker.map = mapview
        
        //animation to make car icon in center of the mapview
        //
        let updatedCamera = GMSCameraUpdate.setTarget(driverMarker.position, zoom: 15.0)
        mapview.animate(with: updatedCamera)
    }
    

    
    //MARK:- MESSAGE VIEW ANIMATION
    func setMessageViewAnimation()
    {
        customTransitioningDelegate.transitionPresent = { [weak self] (fromViewController: UIViewController, toViewController: UIViewController, containerView: UIView, transitionType: TransitionType, completion: @escaping () -> Void) in
            
            guard let weakSelf = self else {
                return
            }
            
            let videoPlayerViewController = toViewController as! messageViewController
            
            if case .simple = transitionType {
                if (weakSelf.videoPlayerViewControllerInitialFrame != nil) {
                    videoPlayerViewController.view.frame = weakSelf.videoPlayerViewControllerInitialFrame!
                    weakSelf.videoPlayerViewControllerInitialFrame = nil
                } else {
                    videoPlayerViewController.view.frame = containerView.bounds.offsetBy(dx: 0, dy: videoPlayerViewController.view.frame.height)
                    videoPlayerViewController.backgroundView.alpha = 0.0
                    videoPlayerViewController.dismissButton.alpha = 0.0
                    videoPlayerViewController.backgroundView.isHidden = true
                }
            }
            
            UIView.animate(withDuration: defaultTransitionAnimationDuration, animations: {
                videoPlayerViewController.view.transform = CGAffineTransform.identity
                videoPlayerViewController.view.frame = containerView.bounds
                videoPlayerViewController.backgroundView.alpha = 1.0
                videoPlayerViewController.dismissButton.alpha = 1.0
                videoPlayerViewController.backgroundView.isHidden = false

                
            }, completion: { (finished) in
                completion()
                // In order to disable user interaction with pan gesture recognizer
                // It is important to do this after completion block, since user interaction is enabled after view controller transition completes
                videoPlayerViewController.view.isUserInteractionEnabled = true
            })
        }
        
        customTransitioningDelegate.transitionDismiss = { [weak self] (fromViewController: UIViewController, toViewController: UIViewController, containerView: UIView, transitionType: TransitionType, completion: @escaping () -> Void) in
            
            guard let weakSelf = self else {
                return
            }
            
            let videoPlayerViewController = fromViewController as! messageViewController
            
            //let finalTransform = CGAffineTransform(scaleX: weakSelf.thumbnailVideoContainerView.bounds.width / videoPlayerViewController.view.bounds.width, y: weakSelf.thumbnailVideoContainerView.bounds.height * 3 / videoPlayerViewController.view.bounds.height)
            
            let finalTransform = CGAffineTransform(scaleX: weakSelf.thumbnailVideoContainerView.bounds.width / videoPlayerViewController.view.bounds.width, y: 1)
            
            UIView.animate(withDuration: defaultTransitionAnimationDuration, animations: {
                videoPlayerViewController.view.transform = finalTransform
                var finalRect = videoPlayerViewController.view.frame
                finalRect.origin.x = weakSelf.thumbnailVideoContainerView.frame.minX
                finalRect.origin.y = weakSelf.thumbnailVideoContainerView.frame.minY
                videoPlayerViewController.view.frame = finalRect
                
                videoPlayerViewController.backgroundView.alpha = 0.0
                videoPlayerViewController.dismissButton.alpha = 0.0
                videoPlayerViewController.backgroundView.isHidden = true

                
            }, completion: { (finished) in
                completion()
                
                videoPlayerViewController.view.isUserInteractionEnabled = false
                weakSelf.addChildViewController(videoPlayerViewController)
                
                var thumbnailRect = videoPlayerViewController.view.frame
                thumbnailRect.origin = CGPoint.zero
                //thumbnailRect.origin.x = (self?.viewMessage.frame.origin.x)!
                //thumbnailRect.origin.y = (self?.viewMessage.frame.origin.y)!
                //thumbnailRect.size.height = Constants.HEIGHT
                videoPlayerViewController.view.frame = thumbnailRect
                self?.subviewWhatTo.transform  = CGAffineTransform(scaleX: 1, y: 1)

                weakSelf.thumbnailVideoContainerView.addSubview(fromViewController.view)
                fromViewController.didMove(toParentViewController: weakSelf)
            })
        }
        
        customTransitioningDelegate.transitionPercentPresent = {[weak self] (fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in
            
            guard let weakSelf = self else {
                return
            }
            
            let videoPlayerViewController = toViewController as! messageViewController
            
            if (weakSelf.videoPlayerViewControllerInitialFrame != nil) {
                weakSelf.videoPlayerViewController.view.frame = weakSelf.videoPlayerViewControllerInitialFrame!
                weakSelf.videoPlayerViewControllerInitialFrame = nil
            }
            
            let startXScale = weakSelf.thumbnailVideoContainerView.bounds.width / containerView.bounds.width
            let startYScale = weakSelf.thumbnailVideoContainerView.bounds.height * 3 / containerView.bounds.height
            
            let xScale = startXScale + ((1 - startXScale) * percentage)
            let yScale = startYScale + ((1 - startYScale) * percentage)
            
            //print("YScale:\(1 - yScale + 0.90)")
            //print("YScale:\(yScale)")

            toViewController.view.transform = CGAffineTransform(scaleX: xScale, y: 1)
            
            self?.subviewWhatTo.transform  = CGAffineTransform(scaleX:(1 - xScale + 0.90), y: (1 - xScale + 0.90))

            
            let startXPos = weakSelf.thumbnailVideoContainerView.frame.minX
            let startYPos = weakSelf.thumbnailVideoContainerView.frame.minY
            let horizontalMove = startXPos - (startXPos * percentage)
            let verticalMove = startYPos - (startYPos * percentage)
            
            var finalRect = toViewController.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            toViewController.view.frame = finalRect
            
            videoPlayerViewController.backgroundView.alpha = 1 - ((1 - percentage) * 2)
            videoPlayerViewController.dismissButton.alpha = percentage
            videoPlayerViewController.backgroundView.isHidden = false

            //videoPlayerViewController.videoViewHeightConstraint.constant = 211.0
        }
        
        customTransitioningDelegate.transitionPercentDismiss = {[weak self] (fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in
            
            guard let weakSelf = self else {
                return
            }
            
            let videoPlayerViewController = fromViewController as! messageViewController
            
            let finalXScale = weakSelf.thumbnailVideoContainerView.bounds.width / videoPlayerViewController.view.bounds.width
            let finalYScale = weakSelf.thumbnailVideoContainerView.bounds.height * 3 / videoPlayerViewController.view.bounds.height
            let xScale = 1 - (percentage * (1 - finalXScale))
            let yScale = 1 - (percentage * (1 - finalYScale))
            
            //print("X:\(xScale)")
            //print("Y:\(yScale)")
            self?.subviewWhatTo.transform  = CGAffineTransform(scaleX:(1 - xScale + 0.90), y: (1 - xScale + 0.90))
            videoPlayerViewController.view.transform = CGAffineTransform(scaleX: xScale, y: 1)
            
            let finalXPos = weakSelf.thumbnailVideoContainerView.frame.minX
            let finalYPos = weakSelf.thumbnailVideoContainerView.frame.minY
            let horizontalMove = min(weakSelf.thumbnailVideoContainerView.frame.minX * percentage, finalXPos)
            let verticalMove = min(weakSelf.thumbnailVideoContainerView.frame.minY * percentage, finalYPos)
            
            var finalRect = videoPlayerViewController.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            videoPlayerViewController.view.frame = finalRect
            
            videoPlayerViewController.backgroundView.alpha = 1 - (percentage * 2)
            videoPlayerViewController.dismissButton.alpha = 1 - (percentage * 2)
            videoPlayerViewController.backgroundView.isHidden = false
        }
    }
    
    func presentMessageView()
    {
        if (self.videoPlayerViewController.parent != nil) {
            self.videoPlayerViewControllerInitialFrame = self.thumbnailVideoContainerView.convert(self.videoPlayerViewController.view.frame, to: self.view)
            self.videoPlayerViewController.removeFromParentViewController()
        }
        
        self.present(self.videoPlayerViewController, animated: true, completion: nil)
        //self.customTransitioningDelegate.finalizeInteractiveTransition(isTransitionCompleted: false)
    }
    
    //MARK:- AUTOCOMPATE TEXTFIELD
    func configureTextField()
    {
        /*
        txtCurrentLocation.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        txtCurrentLocation.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        txtCurrentLocation.autoCompleteCellHeight = 35.0
        txtCurrentLocation.maximumAutoCompleteCount = 20
        txtCurrentLocation.hidesWhenSelected = true
        txtCurrentLocation.hidesWhenEmpty = true
        txtCurrentLocation.enableAttributedText = true
        
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        txtCurrentLocation.autoCompleteAttributes = attributes
        */
    }
    
    func handleTextFieldInterfaces()
    {
        txtCurrentLocation.onTextChange = {[weak self] text in
            self?.isCurrentLocationTextfirldEditing = true
            if !text.isEmpty
            {
                self?.isfindLocation = true
                //self?.setTblFooter((self?.isfindLocation)!)
                
                if let dataTask = self?.dataTask
                {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text, autoTextField: (self?.txtCurrentLocation)!)
            }
            else
            {
                self?.isfindLocation = false
                //self?.setTblFooter((self?.isfindLocation)!)

                self?.tbl.reloadData()
            }
        }
        
        txtWhereTo.onTextChange = {[weak self] text in
            self?.isCurrentLocationTextfirldEditing = false
            if !text.isEmpty
            {
                self?.isfindLocation = true
                //self?.setTblFooter((self?.isfindLocation)!)

                if let dataTask = self?.dataTask
                {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text, autoTextField: (self?.txtWhereTo)!)
            }
            else
            {
                self?.isfindLocation = false
                //self?.setTblFooter((self?.isfindLocation)!)

                self?.tbl.reloadData()
            }
        }

        /*
        txtCurrentLocation.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if let coordinate = placemark?.location?.coordinate
                {
                    self?.addAnnotation(coordinate, address: text)
                    self?.mapView.setCenterCoordinate(coordinate, zoomLevel: 12, animated: true)
                }
            })
        }
         */
    }
    
    
    func fetchAutocompletePlaces(_ inputText : String, autoTextField : AutoCompleteTextField)
    {
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(GoogleMapsRestClient.GMS_API_KEY)&input=\(inputText)"
        
        let s = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        s.addCharacters(in: "+&")
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s as CharacterSet) {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{

                            let result  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                            print(result)
                            
                            if let status = result["status"] as? String
                            {
                                if status == "OK"
                                {
                                    if let predictions = result["predictions"] as? NSArray
                                    {
                                        self.arrLocationList.removeAllObjects()
                                        //var locations = [String]()
                                        for dict in predictions as! [NSDictionary]
                                        {
                                            print(dict)

                                            //let aStr = String(format: "%@%x", "timeNow in hex: ", timeNow)
                                            let tempdict : [String : Any] = [
                                                "place_name":dict.object(forKey: "description"),
                                                "place_address":dict.object(forKey: "description"),
                                                "latitude":"",
                                                "longitude":"",
                                                "isHome":"",
                                                "place_id":dict.object(forKey: "place_id")
                                            ]
                                            self.arrLocationList.add(tempdict)
                                            self.tbl.reloadData()

                                            //locations.append(dict["description"] as! String)i
                                        }
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            //autoTextField.autoCompleteStrings = locations
                                            self.tbl.reloadData()

                                        })
                                        return
                                    }
                                }
                                else
                                {
                                    self.arrLocationList.removeAllObjects()
                                    self.tbl.reloadData()
                                }
                            }
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                autoTextField.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }

    }

    /*
    func setTblFooter(_ isshow: Bool)
    {
        if isshow
        {
            tbl.tableFooterView = viewFooter
        }
        else
        {
            tbl.tableFooterView = nil;
        }
    }
     */
    
    //MARK:- MENU
    @IBAction func menuTapped(_ sender: Any)
    {
        Constants.app_delegate.openSideMenu()
    }
    @IBAction func pinLocationTapped(_ sender: Any)
    {
        self.redirectPinLocation()
    }
    
    func redirectPinLocation()
    {
        let move: PinLocationViewController = storyboard?.instantiateViewController(withIdentifier: "PinLocationViewController") as! PinLocationViewController
        move.FromVC_NAME = "AddLocation"
        navigationController?.pushViewController(move, animated: false)
    }
    
    //MARK:- ZOOM TO REGION (MAPVIEW)
    func zoomToRegion() {
        
        /*
         var region = MKCoordinateRegionMakeWithDistance(location, 15000.0, 15000.0)
         mapview.setRegion(region, animated: true)
         
         UIView.beginAnimations("", context: nil)
         UIView.setAnimationDuration(1.5)
         region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
         mapview.setRegion(region, animated: true)
         UIView.commitAnimations()
         UIView.animate(withDuration: 1.0, animations: {() -> Void in
         })*/
        
        let lat = self.locationManager.location?.coordinate.latitude
        let lan = self.locationManager.location?.coordinate.longitude
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat!, longitude: lan!))
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lan!, zoom: 15.0)
        mapview.camera = camera
        mapview?.animate(to: camera)
        
        
        mapview.isMyLocationEnabled = true
        mapview.delegate = self
        mapview.settings.myLocationButton = false
        
        
        let circleCenter = CLLocationCoordinate2D(latitude: lat!, longitude: lan!)
        let circ = GMSCircle(position: circleCenter, radius: 10000000)
        circ.fillColor = UIColor(red: 89.0/255.0, green: 157.0/255.0, blue: 194.0/255.0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 89.0/255.0, green: 157.0/255.0, blue: 194.0/255.0, alpha: 0.1)
        circ.strokeWidth = 0
        circ.map = mapview
        
        //self.moveLocationButton()
    }
    
    func moveLocationButton() -> Void{
        for object in mapview.subviews{
            for obj in object.subviews{
                if let button = obj as? UIButton{
                    let name = button.accessibilityIdentifier
                    if(name == "my_location"){
                        //config a position
                        button.center = self.view.center
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error is = \(error.localizedDescription)")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = [CLLocation]()
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as? CLLocation
        let coord = locationObj?.coordinate
        
        /*
         let circleCenter = CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
         let circ = GMSCircle(position: circleCenter, radius: 50)
         circ.fillColor = UIColor(red: 89.0/255.0, green: 157.0/255.0, blue: 194.0/255.0, alpha: 1)
         circ.strokeWidth = 0
         circ.map = mapview
         */
        
        /*
         let circleCenter = CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
         let circ = GMSCircle(position: circleCenter, radius: 200)
         circ.fillColor = UIColor.clear
         circ.strokeColor = UIColor(red: 89.0/255.0, green: 157.0/255.0, blue: 194.0/255.0, alpha: 0.4)
         circ.strokeWidth = 1.0
         circ.map = mapview
         */
        
        locationManager = manager
        //fvc.locationLabel.text = ("Location \r\n Latitude: \(coord?.latitude) \r\n Longitude: \(coord?.longitude)")
    }
    
    
    // MARK: - MAPVIEW DELEGATE
    @IBAction func currentLocation(_ sender: Any)
    {
        isLocationTapped = true
        
        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!))
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
        
        mapview?.animate(to: camera)
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.btnCurrentLocation.isHidden = true
        })
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        btnCurrentLocation.isHidden = false
        /*
         if !isLocationTapped {
         btnCurrentLocation.isHidden = false
         }*/
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        if !isLocationTapped
        {
            let lat = mapView.camera.target.latitude
            let lon = mapView.camera.target.longitude
            
            if lat == locationManager.location?.coordinate.latitude && lon == locationManager.location?.coordinate.longitude
            {
                btnCurrentLocation.isHidden = true
            }
            else
            {
                btnCurrentLocation.isHidden = false
            }
        }
        else
        {
            btnCurrentLocation.isHidden = true
            isLocationTapped = false
        }
        
        
        if isopenLocationScreen
        {
            btnCurrentLocation.isHidden = true
        }
        
    }
    
    // MARK: - PICKUP
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
    
    // MARK: - IBACTION
    @IBAction func fromToTapped(_ sender: Any)
    {
        
        //let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        //let region = MKCoordinateRegionMakeWithDistance(location, 500.0, 500.0)
        //mapview.setRegion(region, animated: true)
        
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 20.0)
        mapview?.animate(to: camera)
        
        self.perform(#selector(self.redirectONAddLocation), with: nil, afterDelay: 0.2)
    }
    
    
    func redirectONAddLocation()
    {
        self.locationPopup(true)
        
        /*
         let move: AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
         self.navigationController?.pushViewController(move, animated: false)*/
        
        /*
         UIView.beginAnimations("", context: nil)
         UIView.setAnimationDuration(0.5)
         let move: AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
         self.navigationController?.pushViewController(move, animated: false)
         UIView.commitAnimations()*/
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
    

    // MARK: - LOCATION POPUP
    func locationPopup(_ isopen : Bool)
    {
        Constants.animatewithShow(show: isopen, with: viewLocation)
        btnCurrentLocation.isHidden = isopen
        isopenLocationScreen = isopen

        if isopen
        {
            self.isfindLocation = false
            tbl.reloadData()

            txtWhereTo.becomeFirstResponder()
            self.view.bringSubview(toFront: viewLocation)
            
            
            //Top subview
            viewLocationHeader.frame = CGRect(x:CGFloat(0), y: -viewLocationHeader.frame.size.height, width: CGFloat(Constants.WIDTH), height: viewLocationHeader.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            viewLocationHeader.frame = CGRect(x:CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: viewLocationHeader.frame.size.height)
            UIView.commitAnimations()
            
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.viewLocation.backgroundColor = UIColor.lightGray
            })
            
            
            //Listing
            viewLocationBottom.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: viewLocationBottom.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.6)
            viewLocationBottom.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - viewLocationBottom.frame.size.height, width: CGFloat(Constants.WIDTH), height: viewLocationBottom.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
            
        }
        else
        {
            txtWhereTo.resignFirstResponder()
            txtCurrentLocation.resignFirstResponder()
            
            CATransaction.begin()
            CATransaction.setValue(0.8, forKey: kCATransactionAnimationDuration)
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
            mapview?.animate(to: camera)
            CATransaction.commit()

            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.viewLocation.backgroundColor = UIColor.clear
            })

            //Top subview
            viewLocationHeader.frame = CGRect(x:CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: viewLocationHeader.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.8)
            viewLocationHeader.frame = CGRect(x:CGFloat(0), y: -viewLocationHeader.frame.size.height, width: CGFloat(Constants.WIDTH), height: viewLocationHeader.frame.size.height)
            UIView.commitAnimations()
            
            UIView.animate(withDuration: 0.6, animations: {() -> Void in
            })
            
            
            //Listing
            viewLocationBottom.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - viewLocationBottom.frame.size.height, width: CGFloat(Constants.WIDTH), height: viewLocationBottom.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(1.0)
            viewLocationBottom.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: viewLocationBottom.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
            
            
        }
    }
    
    @IBAction func backFromLocation(_ sender: Any)
    {
        self.locationPopup(false)
        
        self.setInitParam()
        self.popupAnimation()
    }
    
    @IBAction func fromTapped(_ sender: Any)
    {
        txtCurrentLocation.resignFirstResponder()
        txtWhereTo.resignFirstResponder()
        txtWhatTo.resignFirstResponder()
        
        
        czPickerView = CZPickerView(headerTitle: "What To", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        czPickerView?.delegate = self
        czPickerView?.dataSource = self
        czPickerView?.headerBackgroundColor = UIColor(colorLiteralRed: 89/255.0, green: 157/255.0, blue: 194/255.0, alpha: 1)
        czPickerView?.needFooterView = false
        czPickerView?.tag = 101
        czPickerView?.show()
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func hideBottmView(isShow : Bool)
    {
        /*
         if isShow
         {
         viewMessage.isHidden = false
         }
         else
         {
         viewMessage.isHidden = true
         }
         */
        viewMessage.isHidden = true
    }
    
    // MARK: - TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isfindLocation
        {
            return arrLocationList.count
        }
        else
        {
            return arrLocation.count
        }
        //return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isfindLocation
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_HomeWork? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_HomeWork)
            
            if cell == nil {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_HomeWork", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_HomeWork)
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
            }
            
            let dictCell = arrLocationList.object(at: indexPath.row) as! NSDictionary
            
            let strName = dictCell.object(forKey: "place_name") as! String
            let tempArr = strName.components(separatedBy: ",")
            cell?.lbl_placeName.text = tempArr[0]
            
            cell?.lbl_placeAddress.text = dictCell.object(forKey: "place_address") as? String
            
            return cell!

        }
        else
        {
            let CellIdentifier: String = "cell \(Int(indexPath.row))"
            var cell: Cell_setLocation? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_setLocation)
            
            if cell == nil {
                let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_setLocation", owner: nil, options: nil)!
                cell = (topLevelObjects[0] as? Cell_setLocation)
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
            }
            
            let dictCell = arrLocation.object(at: indexPath.row) as! NSDictionary
            
            if indexPath.row == 0
            {
                if Constants.app_delegate.HomeDict == nil
                {
                    cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
                    
                    cell?.subview_Double.isHidden = true
                    cell?.subview_single.isHidden = false
                }
                else
                {
                    cell?.subview_Double.isHidden = false
                    cell?.subview_single.isHidden = true
                    
                    cell?.lblPlaceTitle.text = "Home"
                    //cell?.lblPlaceTitle.text = Constants.app_delegate.HomeDict.value(forKey: "place_name") as? String
                    cell?.lblPlaceAddress.text = Constants.app_delegate.HomeDict.value(forKey: "place_address") as? String
                }
                cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
            }
            else if indexPath.row == 1
            {
                if Constants.app_delegate.WorkDict == nil
                {
                    cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
                    
                    cell?.subview_Double.isHidden = true
                    cell?.subview_single.isHidden = false
                }
                else
                {
                    cell?.subview_Double.isHidden = false
                    cell?.subview_single.isHidden = true
                    
                    cell?.lblPlaceTitle.text = "Work"
                    //cell?.lblPlaceTitle.text = Constants.app_delegate.WorkDict.value(forKey: "place_name") as? String
                    cell?.lblPlaceAddress.text = Constants.app_delegate.WorkDict.value(forKey: "place_address") as? String
                }
                cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
            }
            else
            {
                cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
                cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
            }
            
            /*
             cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
             cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
             */
            
            return cell!
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isfindLocation
        {
            let dictCell = arrLocationList.object(at: indexPath.row) as! NSDictionary
            
            let strName = dictCell.object(forKey: "place_name") as! String
            let tempArr = strName.components(separatedBy: ",")

            let placesClient = GMSPlacesClient()
            let placeID = dictCell.object(forKey: "place_id") as! String

            placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(placeID)")
                    return
                }
                
                /*
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
                 */
                
                
                let dict : [String : Any] = [
                    "place_name":place.name,
                    "place_address":place.formattedAddress,
                    "latitude":place.coordinate.latitude,
                    "longitude":place.coordinate.longitude,
                    "isHome":""
                ]
                Constants.app_delegate.arrselectLocation.add(dict)
                
                if self.isCurrentLocationTextfirldEditing
                {
                    self.txtCurrentLocation.text = tempArr[0]
                    
                    let move: RouteDrawViewController = self.storyboard?.instantiateViewController(withIdentifier: "RouteDrawViewController") as! RouteDrawViewController
                    move.pickupLatLng = CLLocationCoordinate2DMake((self.locationManager.location?.coordinate.latitude)!, (self.locationManager.location?.coordinate.longitude)!)
                    move.destinationLatLng = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                    self.navigationController?.pushViewController(move, animated: true)
                }
                else
                {
                    self.txtWhereTo.text = tempArr[0]
                    
                    let move: RouteDrawViewController = self.storyboard?.instantiateViewController(withIdentifier: "RouteDrawViewController") as! RouteDrawViewController
                    move.pickupLatLng = CLLocationCoordinate2DMake((self.locationManager.location?.coordinate.latitude)!, (self.locationManager.location?.coordinate.longitude)!)
                    move.destinationLatLng = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                    self.navigationController?.pushViewController(move, animated: true)
                }
            })
        }
        else
        {
            self.locationPopup(false)
            
            if indexPath.row == 0
            {
                let move: SearchAddressViewController = storyboard?.instantiateViewController(withIdentifier: "SearchAddressViewController") as! SearchAddressViewController
                move.isFromHome = true
                navigationController?.pushViewController(move, animated: true)
            }
            else if indexPath.row == 1
            {
                let move: SearchAddressViewController = storyboard?.instantiateViewController(withIdentifier: "SearchAddressViewController") as! SearchAddressViewController
                move.isFromHome = false
                navigationController?.pushViewController(move, animated: true)
            }
            else if indexPath.row == 2
            {
                self.locationPopup(false)
                self.redirectPinLocation()
            }
            else if indexPath.row == 3
            {
                let move: RouteDrawViewController = storyboard?.instantiateViewController(withIdentifier: "RouteDrawViewController") as! RouteDrawViewController
                move.pickupLatLng = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
                move.destinationLatLng = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
                navigationController?.pushViewController(move, animated: false)
            }
        }
    }

    
    // MARK: - CZPICKER DELEGATE
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if pickerView.tag == 101 {
            return arrFromvalues.count
        }else{
            return 0;
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if pickerView.tag == 101 {
            return arrFromvalues[row] as! String
        }else{
            return "";
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        if pickerView.tag == 101 {
            txtWhatTo.text = arrFromvalues[row] as? String
            
        }else{
            
        }
    }
    
    
    // MARK: - MESSAGEVIEW DELEGATE
    func rotateButton(radiousbtn: CGFloat)
    {
        var finalRatio = 4 - radiousbtn
        //print(finalRatio)
        
        if finalRatio == 4.0
        {
            self.videoPlayerViewController.dismissButton.transform = CGAffineTransform(rotationAngle: 0)
        }
        else
        {
            finalRatio = finalRatio - 1
            self.videoPlayerViewController.dismissButton.transform = CGAffineTransform(rotationAngle: .pi / -finalRatio)
            //print(.pi / -finalRatio)
            

        }
    }
    
    
    @IBAction func presentTapped(_ sender: Any)
    {
        if (self.videoPlayerViewController.parent != nil) {
            self.videoPlayerViewControllerInitialFrame = self.thumbnailVideoContainerView.convert(self.videoPlayerViewController.view.frame, to: self.view)
            self.videoPlayerViewController.removeFromParentViewController()
        }
        isMessagescreenOpen = true;
        
        self.hideBottmView(isShow: false)
        self.present(self.videoPlayerViewController, animated: true, completion: nil)
        isMessageHidden = true
        //videoPlayerViewController.subview_popup.isHidden = false
        videoPlayerViewController.lblMessage.isHidden = false
        
        videoPlayerViewController.dismissButton.transform = CGAffineTransform(rotationAngle: 0)
        
        
    }
    
    @IBAction func presentFromThumbnailAction(_ sender: AnyObject) {
        guard self.videoPlayerViewController.parent != nil else {
            return
        }
        
        self.videoPlayerViewControllerInitialFrame = self.thumbnailVideoContainerView.convert(self.videoPlayerViewController.view.frame, to: self.view)
        self.videoPlayerViewController.removeFromParentViewController()
        self.present(self.videoPlayerViewController, animated: true, completion: nil)
    }
    
    @IBAction func handlePresentPan(_ panGestureRecozgnizer: UIPanGestureRecognizer) {
        
        guard self.videoPlayerViewController.parent != nil || self.customTransitioningDelegate.isPresenting else {
            return
        }
        
        let translatedPoint = panGestureRecozgnizer.translation(in: self.view)
        
        if (panGestureRecozgnizer.state == .began)
        {
            self.rotateButton(radiousbtn: 0)
            
            //print("BEGIN")
            isMessageHidden = true
            
            self.hideBottmView(isShow: false)
            //videoPlayerViewController.subview_popup.isHidden = false
            videoPlayerViewController.lblMessage.isHidden = false
            
            
            self.videoPlayerViewControllerInitialFrame = self.thumbnailVideoContainerView.convert(self.videoPlayerViewController.view.frame, to: self.view)
            self.videoPlayerViewController.removeFromParentViewController()
            
            self.customTransitioningDelegate.beginPresenting(viewController: self.videoPlayerViewController, fromViewController: self)
            
            self.videoPlayerViewControllerInitialFrame = self.thumbnailVideoContainerView.convert(self.videoPlayerViewController.view.frame, to: self.view)
            
            self.lastVideoPlayerOriginY = self.videoPlayerViewControllerInitialFrame!.origin.y
            
        }
        else if (panGestureRecozgnizer.state == .changed)
        {
            //print("Changed")
            
            let ratio = max(min(((self.lastVideoPlayerOriginY + translatedPoint.y) / self.thumbnailVideoContainerView.frame.minY), 1), 0)
            self.rotateButton(radiousbtn: ratio*2)
            // Store lastPanRatio for next callback
            self.lastPanRatio = 1 - ratio
            // Update percentage of interactive transition
            self.customTransitioningDelegate.update(self.lastPanRatio)
        }
        else if (panGestureRecozgnizer.state == .ended)
        {
            //print("Ended")
            
            // If pan ratio exceeds the threshold then transition is completed, otherwise cancel dismissal and present the view controller again
            let completed = (self.lastPanRatio > self.panRatioThreshold) || (self.lastPanRatio < -self.panRatioThreshold)
            if completed
            {
                self.hideBottmView(isShow: false)
                self.rotateButton(radiousbtn: 0.0)
            }
            else
            {
                self.hideBottmView(isShow: true)
            }
            isMessagescreenOpen = completed
            self.customTransitioningDelegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
        }
    }
}



extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/M_PI)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * .pi / 180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true), coordinate: locationMinMax(positive: false))
    }
}

