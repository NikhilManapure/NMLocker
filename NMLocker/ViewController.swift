//
//  ViewController.swift
//  NMLocker
//
//  Created by Nikhil Manapure on 24/01/17.
//  Copyright © 2017 Nikhil Manapure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setup(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).blurView.showForSetup(withAnimation: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

