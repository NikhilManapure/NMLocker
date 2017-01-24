//
//  LockView.swift
//  Demo
//
//  Created by Nikhil Manapure on 17/01/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

protocol LockViewDelegate {
    func validate(withInputPasscode passcode: String) -> Bool
    func save(passcode: String)
}


enum Purpose : String{
    case lock
    case setup
    case confirmation
}

class LockView: UIView {
    
    let duration : TimeInterval = 0.2
    
    enum IntroText : String{
        case lock           = "Enter passcode"
        case setup          = "Please set your passcode"
        case confirmation   = "Please verify your new passcode"
        case reConfirmation = "Please enter your new passcode"
        case blank          = ""
    }
    
    @IBOutlet weak var pinStack: UIStackView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lhsButton: PinButton!
    @IBOutlet weak var rhsButton: PinButton!
    
    
    var clicks = 0
    var passcode = ""
    var tempPasscode = ""
    var delegate : LockViewDelegate?
    var parent : BlurView?
    var stackView: UIStackView?
    var dotArray = [DotView]()
    var totalDots = 5
    
    var purpose : Purpose = .lock {
        didSet{
            resetSelf()
            rhsButton.isHidden = true
            switch purpose {
            case .lock:
                setIntroText(for: .lock)
                lhsButton.isHidden = true
                break
            case .setup:
                setIntroText(for: .setup)
                lhsButton.isHidden = false
                break
            case .confirmation:
                setIntroText(for: .confirmation)
                lhsButton.isHidden = false
                break
            }
        }
    }
    
    static func instanceFromNib() -> LockView {
        return UINib(nibName: "LockView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LockView
    }
    
    override func draw(_ rect: CGRect) {
        addDots(count: totalDots)
        switch purpose {
        case .lock:
            break
        case .setup:
            break
        case .confirmation:
            break
        }
    }
    
    func addDots(count : Int) {
        dotArray.removeAll()
        for _ in 1...count {
            let dot = DotView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            dot.isFilled = false
            dot.widthAnchor.constraint(equalToConstant: 15).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 15).isActive = true
            dotArray.append(dot)
        }
        stackView?.removeFromSuperview()
        stackView = nil
        stackView = UIStackView(arrangedSubviews: dotArray)
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        stackView?.alignment = .center
        stackView?.spacing = 15
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.backgroundColor = UIColor.brown
        self.addSubview(stackView!)
        stackView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        var a = 15
        a = a * count
        a = a + 15 * (count - 1)
        stackView?.widthAnchor.constraint(equalToConstant: CGFloat(a)).isActive = true
        self.addConstraint(NSLayoutConstraint(item: stackView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.pinStack, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: stackView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.pinStack, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 1))
        self.setNeedsDisplay()
    }

    @IBAction func clicked(_ sender: UIButton) {
        switch sender.tag {
        case -1:
            print("delete \(sender.tag)")
            if self.clicks != 0 {
                dotArray[self.clicks-1].isFilled = false
                self.clicks -= 1
            }
        case -2:
            print("cancelled \(sender.tag)")
            self.parent?.hide(withAnimation: true)
        default:
            print("yep \(sender.tag)")
            passcode = "\(passcode)\(sender.tag)"
            self.clicks += 1
            dotArray[self.clicks-1].isFilled = true
        }
        if self.clicks == totalDots{
            switch self.purpose {
            case .lock:
                if (delegate?.validate(withInputPasscode: passcode))! {
                    self.parent?.hide(withAnimation: true)
                    resetClick()
                } else {
                    feedBackForInvalidPasscode()
                    resetSelf()
                }
            case .setup:
                self.tempPasscode = self.passcode
                self.parent?.showForConfirmation(withAnimation: true)
                resetClick()
            case .confirmation:
                if passcode == self.tempPasscode {
                    self.delegate?.save(passcode: passcode)
                    self.parent?.hide(withAnimation: true)
                    resetClick()
                } else {
                    feedBackForInvalidPasscode()
                    resetSelf()
                    setIntroText(for: .reConfirmation)
                }
                break
            }
        }
        if clicks != 0 {
            rhsButton.isHidden = false
        } else {
            rhsButton.isHidden = true
        }
    }
    
    func resetSelf() {
        resetDots()
        resetClick()
    }
    
    func resetDots() {
        if dotArray.count > 0 {
            for i in 0...dotArray.count-1 {
                dotArray[i].isFilled = false
            }
        }
    }
    
    func resetClick() {
        passcode = ""
        self.clicks = 0
    }
    
    func setIntroText(for text : IntroText) {
        label.text = text.rawValue
    }
    
    func feedBackForInvalidPasscode() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (stackView?.center.x)! - 10, y: (stackView?.center.y)!))
        animation.toValue = NSValue(cgPoint: CGPoint(x: (stackView?.center.x)! + 10, y: (stackView?.center.y)!))
        stackView?.layer.add(animation, forKey: "position")
    }
}
