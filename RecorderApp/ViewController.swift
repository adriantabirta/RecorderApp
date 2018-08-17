//
//  ViewController.swift
//  RecorderApp
//
//  Created by Oneest on 8/16/18.
//  Copyright © 2018 Oneest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var actionButton: RecordButton!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onActionTap(sender: UIButton) {
        // record, play stop
    }
    
    @IBAction func onDeleteTap(sender: UIButton) {
        // record, play stop
    }
}

