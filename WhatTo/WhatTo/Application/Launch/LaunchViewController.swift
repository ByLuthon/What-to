//
//  LaunchViewController.swift
//  WhatTo
//
//  Created by macmini on 16/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
//import SplashScreenUI
//import Commons


class LaunchViewController: UIViewController {

    @IBOutlet weak var imgAnimation: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true

        /*
        let jeremyGif = UIImage.gifImageWithName("PreMask-Animation.gif")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: 183, height: 109)
        imageView.center = self.view.center
        view.addSubview(imageView)*/

        imgAnimation.image = UIImage.gifImageWithName("PreMask-Animation")
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

}
