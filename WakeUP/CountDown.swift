//
//  CountDown.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import Foundation

class CountDown: UIViewController {

    @IBOutlet weak var countDownLabel: UILabel!
    let stop = Date()
    var timer: Timer?
    var difference = -1
    var alarmText = "HH:mm:ss"
    var sent = false
    var received = false
    
    let userAlarm =  NSCalendar.current // to create instance for component
    // defining components
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        received = sent
        //loop for countdown
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
    }
 @objc func  printTime(){
    let startTime = Date()  // current time
print(clock)
    let endTime =  stop + 10
    print(endTime)
     // difference from current to alarm time
     let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
print(timeDifference)
     difference = timeDifference.second!
     if difference == 0 && received == true{
         let wu : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
         wu.modalPresentationStyle = .fullScreen
         self.present(wu, animated: true, completion: nil)
     }
     if difference > -1 {
         let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
         countDownLabel.text = " \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
        difference -= 1
     }
     else {
        self.timer?.invalidate()
     }
 }
}

//
//  ViewController.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/9/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

//import UIKit
//import Foundation
//class Clock{
//    var currentTime : Date{
//        return Date()
//    }
//}
//
//class HomeScreen: UIViewController  {
//    @IBOutlet weak var countdownLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//
//    let clock = Clock()
//    var start = Clock().currentTime
//    var timer : Timer?
//    var timer1: Timer?
//    var difference = -1
//    var dDifference = -1
//    var alarmClock = Date()
//    var alarm = Date()
//    let formatter = DateFormatter()
//    var wakeUpTimer: Timer!
//    var sent = false
//    var received = false
//    var name = ""
//    var sentName = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        alarm = alarmClock
//        sentName = name
//        received = sent
//        print (alarm )
//        self.navigationItem.setHidesBackButton(true, animated: true);
//        // loop for clock
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
//        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
//    }
//    // makes clock appear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateTimeLabel()
//    }
//
//    @objc func updateTimeLabel() {
//        formatter.timeStyle = .short
//        timeLabel.text = formatter.string(from: clock.currentTime as Date)
//    }
//
//    // MARK:- Countdown
//    // Prints Count Down
//    @objc func  printTime(){
//        let userAlarm =  Calendar.current // to create instance for component
//        let startTime = clock.currentTime  // current time
//        let component = userAlarm.dateComponents([.hour, .minute, .second], from: alarm) // this is  from current to alarm
//
//        var endTime = userAlarm.date(bySettingHour: component.hour!, minute: component.minute!, second: component.second!, of: startTime)!
////        print(endTime)
//
//        // difference from current to alarm time
//        let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime)
//
//        // if endtime > how maany hours left in the day, then add new day ?
//
//
//
//
//
//         var components = DateComponents()
//               components.day = 1
//               components.second = -1
//
//               var calendar = Calendar.current
//               calendar.timeZone = TimeZone(abbreviation: "EST")!
//        //        let component = userAlarm.dateComponents([.hour, .minute, .second], from: alarm) // this is  from current to alarm
//
//                let endofDay = calendar.date(bySettingHour: 11, minute: 59, second: 59, of: Date())
//
//                // difference from current to alarm time
//        let dayDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endofDay!)
//
//        if timeDifference.hour == 0 {
//            difference = (timeDifference.minute! * 60) + (timeDifference.second!)
//            dDifference = (dayDifference.minute! * 60) + (dayDifference.second!)
//
//        }
//        if timeDifference.minute == 0{
//            difference = (timeDifference.second!)
//            dDifference = (dayDifference.second!)
//        }
//        else{
//            difference = (timeDifference.hour! * 3600) + (timeDifference.minute! * 60) + (timeDifference.second!)
//            dDifference = (dayDifference.hour! * 3600) + (dayDifference.minute! * 60) + (dayDifference.second!)
//        }
//
//
//        if difference < dDifference || difference == dDifference{
//            if difference == 0 && received == true {
//
//                let tt : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
//                tt.modalPresentationStyle = .fullScreen
//                self.present(tt, animated: true, completion: nil)
//            }
//
//            if difference > -1   {
//                let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
//                countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
//            }
//        }
//
//
//        if difference > dDifference{
//
////            if difference > -1  {
////                // compare until dDiff = 0, add remaining to new day
////                let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
////                countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
////            }
//            // carry over to new day
//            if difference > -1  && dDifference > 0 {
//                let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
//                countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
//            }
//        }
//
//
//
//
//
//
//
//
//        if difference == 0 && received == true {
//            let tt : WakeUpScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Awake") as! WakeUpScreen
//            tt.modalPresentationStyle = .fullScreen
//            self.present(tt, animated: true, completion: nil)
//        }
//
//        if difference > -1   {
//            let timeDifference = userAlarm.dateComponents([.hour,.minute,.second], from: startTime, to: endTime )
//            countdownLabel.text = "\(timeDifference.hour ?? 23) : \(timeDifference.minute ?? 23) : \(timeDifference.second ?? 23) "
//        }
//        else {
//            self.timer1?.invalidate()
//        }
//
//
//
//
//
//
//    }
//}
//// MARK:- Test
//            print ("alarm")
//            print(alarm)
//            print("curr")
//            print(clock.currentTime)
//            print ("diff")
//            print(component)
//            print("end")
//            print(endTime)
// updates text to display the difference


//
//  Settings.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//
