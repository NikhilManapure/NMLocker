//
//  AppDelegate.swift
//  NMLocker
//
//  Created by Nikhil Manapure on 24/01/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var _blurView : BlurView?
    var blurView : BlurView {
        get{
            if _blurView == nil {
                _blurView = BlurView(forWindow: self.window!, andDelegate: self) // wont be needed ever
            }
            return _blurView!
        }
        set{
            _blurView = newValue
        }
    }
    
    var passcode = "11111"
    
    func applicationWillResignActive(_ application: UIApplication) {
        blurView.showJustBlurred(withAnimation: true)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        blurView.hideIfJustBlurred(withAnimation: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        blurView.showWithLock(withAnimation: true)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        blurView = BlurView(forWindow: self.window!, andDelegate: self)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

extension AppDelegate: LockViewDelegate {
    func validate(withInputPasscode passcode: String) -> Bool {
        return passcode == self.passcode
    }
    
    func save(passcode: String) {
        self.passcode = passcode
    }
}
