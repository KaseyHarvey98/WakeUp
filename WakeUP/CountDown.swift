//
//  CountDown.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class CountDown: UIViewController {
    let clock = Clock()
    var start = Clock().alarm
    var timer : Timer?
    var timer1: Timer?
    var difference = -1
    var alarmText = "HH:mm:ss"
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    let userAlarm =  NSCalendar.current // to create instance for component
    // defining components
    let requestedtime : NSCalendar.Unit = [
        NSCalendar.Unit.hour ,
        NSCalendar.Unit.minute,
        NSCalendar.Unit.second
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //loop for countdown
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
    
    @objc func  printTime(){
        
        let startTime = clock.currentTime  // current time
        let endTime =  start + 10 * 60
        
        // difference from current to alarm time
        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        
        difference = timeDifference.second!
        if difference > -1 {
            let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
            countDownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "

        } else {
            timer1?.invalidate()
        }
    }
}
