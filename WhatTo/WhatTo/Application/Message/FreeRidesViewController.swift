//
//  FreeRidesViewController.swift
//  WhatTo
//
//  Created by macmini on 24/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class FreeRidesViewController: UIViewController {

    
    @IBOutlet weak var subviewShareCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam()
    {
        Constants.setBorderTo(subviewShareCode, withBorderWidth: 1, radiousView: 0.0, color: UIColor.lightGray)
    }
    
    @IBAction func cross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func share(_ sender: Any) {
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
