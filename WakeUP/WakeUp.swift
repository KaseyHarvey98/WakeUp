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
    var sent = false // did press snooze
    var alarmSound : AVAudioPlayer?
    var getSound = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let x = UserDefaults.standard.object(forKey: "sound") as? String{
        getSound = x
        }
        let sound = NSDataAsset(name: getSound)!
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try! AVAudioSession.sharedInstance().setActive(true)
            try alarmSound = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            alarmSound!.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           alarmSound?.stop()
       }
}
