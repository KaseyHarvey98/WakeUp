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
    var alarmText = "HH:mm:ss"
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //giving default /"reset"
        countdownLabel.text = alarmText
        // getting alarm input from settings page
        timeLabel.text = alarmText
        // loop for clock
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        //loop for countdown
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func updateTimeLabel() {
        let formatter = DateFormatter()
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
    let formatter1 = DateFormatter() // format string input into date
    let userAlarm =  NSCalendar.current // to create instance for component
    // defining components
    let requestedtime : NSCalendar.Unit = [
        NSCalendar.Unit.hour ,
        NSCalendar.Unit.minute,
        NSCalendar.Unit.second
    ]
    // Prints Count Down
    @objc func  printTime(){
//        let date = Date()
//        print(date.distance(to: Date() + 10))
        
        let startTime = clock.currentTime  // current time
        let endTime =  start + 1 * 60
        
        // difference from current to alarm time
        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        
        difference = timeDifference.second!
        if difference > -1 {
                   let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
            countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
            
            // updates text to display the difference
            
            print(endTime)
            print(countdownLabel.text ?? "0", startTime)
               } else {
                timer1?.invalidate()
        }
    }
}

