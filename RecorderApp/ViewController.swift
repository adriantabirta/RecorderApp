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
    @IBOutlet weak var playButton: UIButton!
    private lazy var recorder = AudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.setTitle("Rec", for: .normal)
        recorder
            .onUpdateTime { [weak self] time in
                self?.timeLabel.text = time
            }
            .onEndPlaying { [weak self] in
                self?.actionButton.isEnabled = true
                self?.playButton.isEnabled = true
            }
    }
    
    @IBAction func onRecordStopAction(sender: UIButton) {
        if recorder.isRecording {
            actionButton.setTitle("Rec", for: .normal)
            recorder.stopRecord()
        } else {
            actionButton.setTitle("Stop", for: .normal)
            recorder.record()
        }
    }
    
    @IBAction func onPlayAction(sender: UIButton) {
        actionButton.isEnabled = false
        playButton.isEnabled = false
        recorder.play()
    }
}

