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
        AudioServicesPlaySystemSound(1130)
        super.viewDidLoad()
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
    
//    
//    public func simpleAddNotification(hour: Int, minute: Int, identifier: String, title: String, body: String) {
//        // Initialize User Notification Center Object
//        let center = UNUserNotificationCenter.current()
//
//        // The content of the Notification
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        // The selected time to notify the user
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.hour = 1
//        dateComponents.minute = 47
//
//        // The time/repeat trigger
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        // Initializing the Notification Request object to add to the Notification Center
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        // Adding the notification to the center
//        center.add(request) { (error) in
//            if (error) != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
    
}
