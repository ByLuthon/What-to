//
//  ViewController.swift
//  WhatTo
//
//  Created by macmini on 08/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    //MARK:-  IBOutlets
    @IBOutlet weak var subview: UIView!

    
    
    override func viewDidLoad()
    {
        navigationController?.isNavigationBarHidden = true
        
        self.setInitParam()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setInitParam()
    {
        subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: subview.frame.size.height)
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.4)
        subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - subview.frame.size.height, width: CGFloat(Constants.WIDTH), height: subview.frame.size.height)
        UIView.commitAnimations()
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
        })

    }
    
    @IBAction func numberTapped(_ sender: Any)
    {
        let move: MainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        navigationController?.pushViewController(move, animated: true)
    }

}

