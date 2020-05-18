//
//  Settings.swift
//  WakeUP
//
//  Created by Kasey Harvey on 4/20/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class Settings: UITableViewController{
    
    @IBOutlet weak var alarmSound: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var alarmTime: UIDatePicker!
    // Goes to home screen vis button
    @IBAction func save(_ sender: Any) {
        sent = true
        performSegue(withIdentifier: "transfer", sender: self)
    }
    // deletes alarm
    @IBAction func Delete(_ sender: Any) {
        delete = true
    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private var datePicker : UIDatePicker?
    var alarmText = Date()
    var sent = false
    var delete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Changes text color of UI Picker
        alarmTime.setValue(UIColor.white, forKeyPath: "textColor")
        // Set time to User Default
        if let x = UserDefaults.standard.object(forKey: "alarm") as? Date{
            alarmText = x
            alarmTime.date = x
        }
        if let x = UserDefaults.standard.object(forKey: "name") as? String{
            nameLabel.text = x
        }
        if let x = UserDefaults.standard.object(forKey: "sound") as? String{
        alarmSound.setTitle(x, for: .normal)
        }
        // times alarmTime, user changed time
        alarmTime.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        // Tracks to see if user tapped out of input
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int { return 4 }
    
    // MARK:- Transfer Time and Name / Set Defaults
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        sent = true
        if delete == true {
            sent = false
        }
        if nameLabel.text == nil{
            nameLabel.text = "John Doe"
        }
        UserDefaults.standard.set(self.alarmText, forKey: "alarm")
        UserDefaults.standard.set(self.nameLabel.text, forKey: "name")
        UserDefaults.standard.set(sent, forKey: "recieved")
    }
    // When tapped outside of keyboard, it hides
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    // when date is change, records it
    @objc func dateChanged(datePicker : UIDatePicker) {
        alarmText = datePicker.date
    }
}
