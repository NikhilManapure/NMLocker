//
//  PinButton.swift
//  Demo
//
//  Created by Nikhil Manapure on 19/01/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

@IBDesignable class PinButton: UIButton {
    
    @IBInspectable var borderColor : UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        if self.titleLabel?.text?.characters.count == 1 {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = borderColor.cgColor
            self.layer.cornerRadius = self.bounds.size.height / 2
            self.clipsToBounds = true
        }
    }
 }
