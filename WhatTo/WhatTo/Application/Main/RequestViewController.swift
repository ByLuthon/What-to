//
//  RequestViewController.swift
//  WhatTo
//
//  Created by macmini on 23/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    
    @IBOutlet weak var scrl: UIScrollView!
    @IBOutlet var subviewScrl: UIView!
    
    @IBOutlet weak var img_findingYourRides: UIImageView!
    @IBOutlet var viewCancelTrip: UIView!
    @IBOutlet weak var subviewCancelTrip: UIView!
    @IBOutlet weak var btnCancelTripNo: UIButton!
    @IBOutlet weak var btnCancelTripYes: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setInitParam()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back(_ sender: Any)
    {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectMainScreen"), object: nil, userInfo: nil)

        self.dismiss(animated: true, completion: nil)
    }

    func setInitParam()
    {
        viewCancelTrip.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        subviewScrl.frame = CGRect(x: 0, y: Constants.HEIGHT, width: Constants.WIDTH, height: subviewScrl.frame.size.height)
        self.view.addSubview(viewCancelTrip)
        viewCancelTrip.isHidden = true
        Constants.setBorderTo(btnCancelTripNo, withBorderWidth: 0.5, radiousView: 2, color: UIColor.darkGray)
        Constants.setBorderTo(btnCancelTripYes, withBorderWidth: 0.5, radiousView: 2, color: UIColor.darkGray)
        
        
        subviewScrl.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: subviewScrl.frame.size.height)
        scrl.addSubview(subviewScrl)
        
        Constants.setBorderTo(img_findingYourRides, withBorderWidth: 0, radiousView: Float(img_findingYourRides.frame.size.height/2), color: UIColor.clear)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    

    @IBAction func CancelTrip(_ sender: Any)
    {
        Constants.animatewithShow(show: true, with: viewCancelTrip)
        self.popupWithAnimation(_subview: subviewCancelTrip, show: true)
    }
    
    @IBAction func closeCancelPopup(_ sender: Any)
    {
        self.hideCancelPopup()
    }
    
    @IBAction func cancelTrip_Yes(_ sender: Any)
    {
        self.hideCancelPopup()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectMainScreen"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func CancelTrip_NO(_ sender: Any)
    {
        self.hideCancelPopup()
    }
    
    func hideCancelPopup()
    {
        Constants.animatewithShow(show: false, with: viewCancelTrip)
        self.popupWithAnimation(_subview: subviewCancelTrip, show: false)
    }
}
