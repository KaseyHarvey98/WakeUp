//
//  Settings.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
 import AVFoundation

class Settings: UITableViewController{
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var alarmTime: UITextField!
    
    private var datePicker : UIDatePicker?
    var player: AVAudioPlayer?
    var alarmText = Date()
    var sent = false
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        self.navigationItem.setHidesBackButton(true, animated: true)
        if let x = UserDefaults.standard.object(forKey: "alarm") as? Date{
            alarmText = x
            alarmTime.text = dateFormatter.string(from: alarmText)
        }
        if let x = UserDefaults.standard.object(forKey: "name") as? String{
            nameLabel.text = x
        }
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        alarmTime.inputView = datePicker
        
    }
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker : UIDatePicker) {
        alarmTime.text = dateFormatter.string(from: datePicker.date)
        alarmText = dateFormatter.date(from: alarmTime.text!)!
    }
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int { return 2 }
   
    // MARK:- Transfer Time and Name
    @IBAction func save(_ sender: Any) {
        performSegue(withIdentifier: "transfer", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sent = true
        UserDefaults.standard.set(self.alarmText, forKey: "alarm")
        UserDefaults.standard.set(self.nameLabel.text, forKey: "name")
        UserDefaults.standard.set(sent, forKey: "recieved")
        print(alarmText)
    }
    
    // MARK:- PICK SOUND

    

    func playSound() {
        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
