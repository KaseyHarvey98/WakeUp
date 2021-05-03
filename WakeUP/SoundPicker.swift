//
//  SoundPicker.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/17/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import AVFoundation

// MPMediaController -- MPMedia


class SoundPicker: UITableViewController {
    
    // Plays sound preview
    
    @IBAction func Hot(_ sender: Any) {
        let sound = NSDataAsset(name: "Hotline")!
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try! AVAudioSession.sharedInstance().setActive(true)
            try alarmSound = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            alarmSound!.play()
        } catch {
            // couldn't load file :(
        }
        UserDefaults.standard.set("Hotline", forKey: "sound")
    }
    
    @IBAction func Clas(_ sender: Any) {
        let sound = NSDataAsset(name: "Classic")!
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try! AVAudioSession.sharedInstance().setActive(true)
            try alarmSound = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            alarmSound!.play()
        } catch {
            // couldn't load file :(
        }
        UserDefaults.standard.set("Classic", forKey: "sound")
    }
    @IBAction func Sir(_ sender: Any) {
        let sound = NSDataAsset(name: "Siren")!
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try! AVAudioSession.sharedInstance().setActive(true)
            try alarmSound = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.wav.rawValue)
            alarmSound!.play()
        } catch {
            // couldn't load file :(
        }
         UserDefaults.standard.set("Siren", forKey: "sound")
    }
    
    var alarmSound: AVAudioPlayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        alarmSound?.stop()
    }
    
}
