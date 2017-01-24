//
//  DotView.swift
//  Demo
//
//  Created by Nikhil Manapure on 20/01/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

@IBDesignable class DotView: UIView {
    
    let borderWidth : CGFloat = 1.0
    
    var isFilled : Bool {
        set{
            if newValue {
                self.backgroundColor = filledColor

            } else {
                self.backgroundColor = unFilledColor

            }
        }
        get{
            return self.backgroundColor == filledColor
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var filledColor : UIColor = UIColor.green {
        didSet {
            self.layer.backgroundColor = filledColor.cgColor
        }
    }
    
    @IBInspectable var unFilledColor : UIColor = UIColor.red {
        didSet {
            self.layer.backgroundColor = unFilledColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.layer.backgroundColor = unFilledColor.cgColor
        self.clipsToBounds = true
    }
}
