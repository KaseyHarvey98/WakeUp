//
//  Morning.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit

class Morning: UIViewController {
    
    @IBOutlet weak var nameGreeting: UILabel!
    var finalName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        nameGreeting.text = finalName
    }
    

}
