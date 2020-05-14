//
//  ViewController.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/9/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    let clock = Clock()
    var start = Clock().alarm
    var timer : Timer?
    var timer1: Timer?
    var difference = -1
    var alarmClock = Date()
    var alarm = Date()
    let formatter = DateFormatter()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //giving default /"reset"
        // getting alarm input from settings page
        alarm = alarmClock
        // loop for clock
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabel() {
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: clock.currentTime as Date)
    }
    // makes clock appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
    }
    
    // MARK:- Countdown
    @IBOutlet weak var countdownLabel: UILabel!
    // Prints Count Down
    @objc func  printTime(){
        let userAlarm =  Calendar.current // to create instance for component
        let startTime = clock.currentTime  // current time
        let component = userAlarm.dateComponents([.hour, .minute, .second], from: alarm)
        let endTime = userAlarm.date(bySettingHour: component.hour!, minute: component.minute!, second: component.second!, of: startTime)!
        // difference from current to alarm time
        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        
        difference = timeDifference.second!
        if difference > -1 {
            let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
            countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
            print ("alarm")
            print(alarm)
            print("curr")
            print(clock.currentTime)
            print ("diff")
            print(component)
            print("end")
            print(endTime)
            // updates text to display the difference
        } else {
            timer1?.invalidate()
        }
    }
}

