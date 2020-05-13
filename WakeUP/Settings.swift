//
//  Settings.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class Settings: UITableViewController{
    //
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var alarmTime: UITextField!
    private var datePicker : UIDatePicker?
    var alarmText = "00:00:00"
    var nameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        alarmTime.text = dateFormatter.string(from: datePicker.date)
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int { return 2 }
    // MARK:- Transfer Time
    @IBAction func done(_ sender: Any) {
        self.alarmText = alarmTime.text!
        performSegue(withIdentifier: "alarm", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let at = segue.destination as! ViewController
        at.alarmText = self.alarmText
    }
    
    
    
    
//    @IBAction func done2(_ sender: Any) {
//        self.nameText = nameLabel.text!
//        performSegue(withIdentifier: "name", sender: self)
//    }
//    func prepare1(for segue: UIStoryboardSegue, sender: Any?) {
//        let nt = segue.destination as! Morning
//        nt.finalName = self.nameText
//    }

    
    
}
