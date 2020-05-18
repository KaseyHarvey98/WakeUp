//
//  CountDown.swift
//  WakeUP
//
//Created by Kasey Harvey on 4/20/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import Foundation

class CountDown: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    // Go to HomeScreen via button
    @IBAction func End(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    // Go to WakeUp Screen via button
    @IBAction func WakeUp(_ sender: Any) {
        let mc : Morning = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Greet") as! Morning
        mc.modalPresentationStyle = .fullScreen
        self.present(mc, animated: true, completion: nil)
    }
    
    let userAlarm =  NSCalendar.current // To create instance for component
    let stop = Date()
    var timer: Timer?
    var difference = -1
    var alarmText = "HH:mm:ss"
    var sent = false
    var received = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        received = sent
        //loop for countdown
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
    
    @objc func  printTime(){
        let startTime = Date()  // current time
        let endTime =  stop + 9 * 60  // 9 min snooze
        // difference from current to alarm time
        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        difference = timeDifference.second!
        // If countdown is done, go to wake up screen
        if difference == 0 && received == true{
            let wu : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
            wu.modalPresentationStyle = .fullScreen
            self.present(wu, animated: true, completion: nil)
        }
        // If not done, print time
        if difference > -1 {
            let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
            let differM = timeDifference.minute!
            let differS = timeDifference.second!
            countDownLabel.text = String(format:"%02i:%02i", differM, differS )
            difference -= 1
        }
        else {
            self.timer?.invalidate()
        }
    }
}
