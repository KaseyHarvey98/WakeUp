//
//  ViewController.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/9/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import Foundation
class Clock{
    var currentTime : Date{
        return Date()
    }
}

class HomeScreen: UIViewController  {
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let clock = Clock()
    var start = Clock().currentTime
    var timer : Timer?
    var timer1: Timer?
    var difference = -1
    var alarmClock = Date()
    var alarm = Date()
    let formatter = DateFormatter()
    var wakeUpTimer: Timer!
    var sent = false
    var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print (alarm )
        if let x = UserDefaults.standard.object(forKey: "alarm") as? Date{
            print (alarm)
            alarm = x
        }
        if let y = UserDefaults.standard.object(forKey: "recieved") as? Bool{
            received = y
        }
        self.navigationItem.setHidesBackButton(true, animated: true);
        // loop for clock
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
    // makes clock appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
    }

    @objc func updateTimeLabel() {
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: clock.currentTime as Date)
    }
    
    // MARK:- Countdown
    // Prints Count Down
    @objc func  printTime(){
        let userAlarm =  Calendar.current // to create instance for component
        let startTime = clock.currentTime  // current time
        // if end == negative  need to subtract from new day
        let component = userAlarm.dateComponents([.hour, .minute, .second], from: alarm) // this is  from current to alarm
        let endTime = userAlarm.date(bySettingHour: component.hour ?? 23, minute: component.minute ?? 23, second: component.second ?? 23, of: startTime)!
        // difference from current to alarm time
        var timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        
        var differH = timeDifference.hour!
        var differM = timeDifference.minute!
        var differS = timeDifference.second!
        
        if  (timeDifference.hour! < 0) || (timeDifference.minute! < 0) || (timeDifference.second! < 0) {
            if (timeDifference.hour! == 0) {
                differH = timeDifference.hour!
            }
            if (timeDifference.minute! == 0) {
                differM = timeDifference.minute!
            }
            if (timeDifference.second! == 0) {
                           differS = timeDifference.second!
                       }
            else{
            differH = timeDifference.hour! + 24
            differM = timeDifference.minute! + 60
            differS = timeDifference.second! + 60}
        }
        
        // if endtime > how maany hours left in the day, then add new day ?
        
        if ((timeDifference.hour == 0) && ((timeDifference.minute != 0) || (timeDifference.second != 0))){
            difference = (differM * 60) + (differS)
        }
        if (((timeDifference.hour == 0) && (timeDifference.minute == 0)) && (timeDifference.second != 0)){
            difference = (differS)
        }
        if (((timeDifference.hour != 0) || (timeDifference.minute != 0) || (timeDifference.second != 0))){
            
            difference = (differH * 3600) + (differM * 60) + (differS)
        }
        if difference == 1 && received == true {
            let tt : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
            tt.modalPresentationStyle = .fullScreen
            self.present(tt, animated: true, completion: nil)
        }
        if difference > -1 && received == true{
            timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
            var differH = timeDifference.hour!
            var differM = timeDifference.minute!
            var differS = timeDifference.second!
            if  (timeDifference.hour! < 0) || (timeDifference.minute! < 0) || (timeDifference.second! < 0) {
                differH = timeDifference.hour! + 24
                differM = timeDifference.minute! + 60
                differS = timeDifference.second! + 60
            }
            countdownLabel.text = String(format:"%02i:%02i:%02i", differH, differM, differS )
        }
        else {
            self.timer1?.invalidate()
        }
        // from wake up screen to home
        //@IBAction func unwindToMe(segue: UIStoryboardSegue){}
        //    }
        //    func calculate(date: DateComponents ) -> Int{
        //
        //
        //        var difference
        //        var differH = timeDifference.hour!
        //
        //                   var differM = date.minute!
        //                   var differS = date.second!
        //
        //                   if  (date.hour! < 0) || (date.minute! < 0) || (date.second! < 0) {
        //                       differH = date.hour! + 24
        //                       differM = date.minute! + 60
        //                       differS = date.second! + 60
        //                        }
        //        return difference
    }
}
// MARK:- Test
//            print ("alarm")
//            print(alarm)
//            print("curr")
//            print(clock.currentTime)
//            print ("diff")
//            print(component)
//            print("end")
//            print(endTime)
// updates text to display the difference
