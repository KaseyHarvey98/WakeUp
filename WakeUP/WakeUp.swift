//
//  WakeUp.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class WakeUpScreen: UIViewController {
    var sent = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToMS(_ sender: Any) {
        let mc : Morning = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Greet") as! Morning
        mc.modalPresentationStyle = .fullScreen
        self.present(mc, animated: true, completion: nil)
    }
  
    @IBAction func End(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToCD(_ sender: Any) {
        sent = true
        let cd : CountDown = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CD") as! CountDown
        cd.modalPresentationStyle = .fullScreen
        cd.sent = self.sent
        self.present(cd, animated: true, completion: nil)
    }
    
}
