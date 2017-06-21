//
//  messageViewController.swift
//  WhatTo
//
//  Created by macmini on 19/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit



class messageViewController: UIViewController {

    @IBOutlet weak var videoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoViewAtBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var lblMessage: UILabel!

    @IBOutlet weak var subview_popup: UIView!
    var handlePan: ((_ panGestureRecognizer: UIPanGestureRecognizer) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.setBorderTo(subview_popup, withBorderWidth: 5, radiousView: 0, color: UIColor.clear)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        self.handlePan?(sender)
    }
    
    @IBAction func dismissAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func share(_ sender: Any)
    {
        let activityViewController = UIActivityViewController(
            activityItems: ["Hello, Welcome to UBER"],
            applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
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
