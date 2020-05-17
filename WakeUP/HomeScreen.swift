//
//  HomeScreen.swift
//  WakeUP
//
//  Created by Kasey Harvey on 4/20/20.
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
    let formatter = DateFormatter()
    var start = Clock().currentTime
    var timerC : Timer? // Timer for clock
    var timerCD: Timer? //Timer for count down
    var difference = -1 // Initiate difference of time
    var alarm = Date()
    var sent = false // input from Settings
    var received = false // saved input from Settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Save alarm
        if let x = UserDefaults.standard.object(forKey: "alarm") as? Date{
            alarm = x
        }
        if let y = UserDefaults.standard.object(forKey: "recieved") as? Bool{
              self.timerCD?.invalidate()
            received = y
        }
        // Hide back button on Home Screen (cant go back from here)
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        timerC = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true) // loop for clock updates
        timerCD = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true) // loop for countdown updates
    }
    // Clock and countdown appear as soon as screen is up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
    }
    // MARK:- Clock
    // Clock is formatted correctly
    @objc func updateTimeLabel() {
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: clock.currentTime as Date)
    }
    
    // MARK:- Countdown
    // Prints Count Down
    @objc func  printTime(){
        let userAlarm =  Calendar.current // to create instance for component
        let startTime = clock.currentTime  // current time
        // from time current to alarm
        let component = userAlarm.dateComponents([.hour, .minute, .second], from: alarm)
        // from end time of alarm
        let endTime = userAlarm.date(bySettingHour: component.hour ?? 23, minute: component.minute ?? 23, second: component.second ?? 23, of: startTime)!
        // difference from current to alarm time
        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
        // Save time components **Will return negative if time is in the past
        var differH = timeDifference.hour!
        var differM = timeDifference.minute!
        var differS = timeDifference.second!
        // If time is in the past, make positive
        if  (timeDifference.hour! < 0) || (timeDifference.minute! < 0) || (timeDifference.second! < 0) {
            differH = timeDifference.hour! + 24
            differM = timeDifference.minute! + 60
            differS = timeDifference.second! + 60
        }
        // Time diference is written in base value ( 1 hour = 1 difference). This converts to seconds
        if ((timeDifference.hour == 0) && ((timeDifference.minute != 0) || (timeDifference.second != 0))){
            difference = (differM * 60) + (differS)
        }
        if (((timeDifference.hour == 0) && (timeDifference.minute == 0)) && (timeDifference.second != 0)){
            difference = (differS)
        }
        if (((timeDifference.hour != 0) || (timeDifference.minute != 0) || (timeDifference.second != 0))){
            
            difference = (differH * 3600) + (differM * 60) + (differS)
        }
        // If countdown is done, go to wake up screen
        if difference == 1 && received == true {
            difference = 0 // reset difference
            let tt : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
            tt.modalPresentationStyle = .fullScreen
            self.present(tt, animated: true, completion: nil)
        }
        // If not done, print time
        if difference > -1 && received == true{
            countdownLabel.text = String(format:"%02i:%02i:%02i", differH, differM, differS )
            difference = 0 // reset difference
        }
        else {
            self.timerCD?.invalidate()
        }
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
