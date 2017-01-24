//
//  BlurView.swift
//  Demo
//
//  Created by Nikhil Manapure on 19/01/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

class BlurView: UIVisualEffectView {
    
    let duration : TimeInterval = 0.2

    var lockView : LockView?
    var parent   : UIWindow?
    var delegate : LockViewDelegate?
    
    var isLocked : Bool {
        get{
            return !(self.lockView!.isHidden)
        }
        set{
            if newValue {
                self.lockView!.resetDots()
            }
            self.lockView!.isHidden = !newValue
        }
    }
    
    init(forWindow window : UIWindow, andDelegate delegate: LockViewDelegate) {
        let blurEffect = UIBlurEffect(style: .light)
        super.init(effect : blurEffect)
        self.parent = window
        self.frame = window.bounds
        self.isHidden = true
        self.lockView = LockView.instanceFromNib()
        self.lockView?.isHidden = true
        self.addSubview(self.lockView!)
        self.lockView?.center = self.center
        self.lockView?.delegate = delegate
        self.delegate = delegate
        self.lockView?.parent = self
    }
    
    private func show(withAnimation animated: Bool){
        if self.add(to: self.parent!) {
            if animated {
                self.layer.removeAllAnimations()
                self.alpha = 0.3
                UIView.animate(withDuration: duration , delay: 0, options: .allowUserInteraction , animations: {() -> Void in
                    self.alpha = 1
                }, completion:  {(_ finished: Bool) -> Void in
                    if finished {
                        // Lock is shown
                    }else {
                        //Revert
                        self.hide(withAnimation: false)
                    }
                })
            } else {
                self.alpha = 1
            }
        }
    }
    
    func showJustBlurred(withAnimation animated: Bool){
        show(withAnimation: animated)
    }
    
    
    func showWithLock(withAnimation animated: Bool){
        self.isLocked = true
        self.lockView?.purpose = .lock
        show(withAnimation: animated)
    }
    
    func showForSetup(withAnimation animated: Bool){
        self.isLocked = true
        self.lockView?.purpose = .setup
        show(withAnimation: animated)
    }
    
    func showForConfirmation(withAnimation animated: Bool){
        self.isLocked = true
        self.lockView?.purpose = .confirmation
        show(withAnimation: animated)
    }
    
    func hide(withAnimation animated: Bool) {
        if animated {
            self.layer.removeAllAnimations()
            UIView.animate(withDuration: duration , delay: 0, options: .allowUserInteraction , animations: {() -> Void in
                self.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                if finished {
                    //Lock is removed
                    self.isHidden = true
                    self.isLocked = false
                    self.removeFromSuperview()
                }else {
                    //Revert
                    self.alpha = 1
                }
            })
        } else {
            self.alpha = 0
            self.isHidden = true
            self.removeFromSuperview()
        }
    }

    func hideIfJustBlurred(withAnimation animated: Bool){
        if isPresent(on: parent!){
            if !self.isLocked {
                hide(withAnimation: animated)
            }
        }
    }
    
    private func add(to window : UIWindow) -> Bool{
        var ifAdded = false
        if !isPresent(on: window){
            self.isHidden = false
            self.alpha = 0
            window.addSubview(self)
            window.bringSubview(toFront: self)
            ifAdded = true
        }
        return ifAdded
    }
    
    func isPresent(on window : UIWindow) -> Bool{
        return ((window.subviews.contains(self)))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
