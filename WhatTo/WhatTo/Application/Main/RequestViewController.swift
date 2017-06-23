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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectMainScreen"), object: nil, userInfo: nil)

        self.dismiss(animated: true, completion: nil)
    }

    func setInitParam()
    {
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

}
