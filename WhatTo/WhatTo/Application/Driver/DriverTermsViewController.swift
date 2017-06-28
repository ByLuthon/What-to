//
//  DriverTermsViewController.swift
//  WhatTo
//
//  Created by macmini on 28/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class DriverTermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func Back(_ sender: Any)
    {
        navigationController?.pop(animated: true)
    }

    @IBAction func Continue(_ sender: Any) {
    }
    
    @IBAction func Help(_ sender: Any) {
    }
    
}
