//
//  BottomBorderedTextField.swift
//  MangJek
//
//  Created by Muhammad Ridho on 16.10.16.
//  Copyright © 2016 Gumcode. All rights reserved.
//

import UIKit

class BottomBorderedTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)    }
    
    func setBottomBorder() {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        
        self.layer.addSublayer(bottomLine)
    }
    
    func setCustomPlaceholder(_ placeholder: String) {
        let usernamePlaceholderAttr = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.attributedPlaceholder = usernamePlaceholderAttr
    }
 

}
