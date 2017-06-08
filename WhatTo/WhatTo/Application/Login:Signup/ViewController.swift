//
//  ViewController.swift
//  WhatTo
//
//  Created by macmini on 08/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad()
    {
        navigationController?.isNavigationBarHidden = true
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberTapped(_ sender: Any)
    {
        let move: MainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        navigationController?.pushViewController(move, animated: true)
    }

}

