//
//  Cell_settingProfile.swift
//  WhatTo
//
//  Created by macmini on 27/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class Cell_settingProfile: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib()
    {
        Constants.setBorderTo(imgProfile, withBorderWidth: 1.0, radiousView: Float(imgProfile.frame.size.height/2), color: UIColor.gray)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
