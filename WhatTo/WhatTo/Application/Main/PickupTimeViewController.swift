//
//  PickupTimeViewController.swift
//  WhatTo
//
//  Created by macmini on 09/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class PickupTimeViewController: UIViewController {

    //MARK:-  IBOutlets
    @IBOutlet weak var lblSelectDateAndTime: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblBG: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(self.setAnimation), with: nil, afterDelay: 0.4)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAnimation() {
        lblBG.alpha = 0.0
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.4)
        lblBG.alpha = 0.4
        UIView.commitAnimations()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
        })
    }
    
    @IBAction func PickupTime_tapped(_ sender: Any) {
    }

    @IBAction func hideScreenTapped(_ sender: Any) {
        lblBG.alpha = 0.0
        dismiss(animated: true, completion: nil)
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
