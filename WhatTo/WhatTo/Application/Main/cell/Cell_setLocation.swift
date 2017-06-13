//
//  Cell_setLocation.swift
//  WhatTo
//
//  Created by macmini on 09/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class Cell_setLocation: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPlaceTitle: UILabel!
    @IBOutlet weak var lblPlaceAddress: UILabel!
    
    @IBOutlet weak var subview_single: UIView!
    @IBOutlet weak var subview_Double: UIView!
    
    override func awakeFromNib()
    {
        Constants.setBorderTo(imgIcon, withBorderWidth: 0, radiousView: 0, color: UIColor.clear)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
