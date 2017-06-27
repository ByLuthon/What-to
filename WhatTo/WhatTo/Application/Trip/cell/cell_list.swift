//
//  cell_list.swift
//  WhatTo
//
//  Created by macmini on 27/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class cell_list: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
