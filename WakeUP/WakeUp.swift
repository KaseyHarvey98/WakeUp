//
//  WakeUp.swift
//  WakeUP
//
//  Created by Kasey Harvey on 4/20/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import AVFoundation

class WakeUpScreen: UIViewController {
    var sent = false // did press snooze
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioServicesPlaySystemSound(1130)
    }
    // Go to Morning via button
    @IBAction func goToMS(_ sender: Any) {
        let mc : Morning = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Greet") as! Morning
        mc.modalPresentationStyle = .fullScreen
        self.present(mc, animated: true, completion: nil)
    }
  // Go to HomeScreen via button
    @IBAction func End(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    // Go to Countdown via button
    @IBAction func goToCD(_ sender: Any) {
        sent = true
        let cd : CountDown = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CD") as! CountDown
        cd.modalPresentationStyle = .fullScreen
        cd.sent = self.sent
        self.present(cd, animated: true, completion: nil)
    }
    
    
   
    
}
