//
//  AudioRecorder2.swift
//  RecorderApp
//
//  Created by Oneest on 8/17/18.
//  Copyright © 2018 Oneest. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject {

    private var recorder: AVAudioRecorder!
    private var player: AVAudioPlayer!
    private var meterTimer: Timer!
    private var playTimer: Timer!
    private var updateTimeClosure: (_ time: String) -> Void = { _ in }
    private var endPlayingClosure: () -> Void = { }

    private var isRecordingInternal = false
    
    override init() {
        super.init()
        checkPermissions()
        setSessionPlayAndRecord()
    }
    
    var isRecording: Bool {
        return isRecordingInternal
    }
    
    @discardableResult
    func onUpdateTime(_ closure: @escaping (_ time: String) -> Void) -> Self {
        updateTimeClosure = closure
        return self
    }
    
    @discardableResult
    func onEndPlaying(_ closure: @escaping () -> Void) -> Self {
        endPlayingClosure = closure
        return self
    }
    
    func record() {

        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            setupRecorder()
            rec()
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
        } else {
            print("recording")
            rec()
        }
    }
    
    func stopRecord() {
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        isRecordingInternal = false
        recorder = nil
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    func play() {
        do {
            self.player = try AVAudioPlayer(contentsOf: getFileUrl())
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updatePlayedTime(_:)), userInfo: nil, repeats: true)
        } catch {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    func checkPermissions() {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case .denied: Alert().message("Cannot use app without rec permissions").show()
        case .granted: break
        case .undetermined: askForPermissions()
        }
    }
    
    func askForPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission() { allowed in
            guard !allowed else { return }
            Alert().message("Cannot use app without  permissions").show()
        }
    }
}

extension AudioRecorder {
    
    private func rec() {
        setSessionPlayAndRecord()
        recorder.record()
        isRecordingInternal = true
        meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioMeter(_:)), userInfo: nil, repeats: true)
    }
    
    private func getFileUrl() -> URL {
        let currentFileName = "record.m4a"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(currentFileName)
    }
    
    private func setupRecorder() {
        
//        if FileManager.default.fileExists(atPath: getFileUrl().absoluteString) {
//            // probably won't happen. want to do something about it?
//            print("soundfile \(getFileUrl().absoluteString) exists")
//        }
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: getFileUrl(), settings: recordSettings)
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    private func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)

        } catch {
            print("could not set session ")
            print(error.localizedDescription)
        }
    }
    
    @objc private func updateAudioMeter(_ timer: Timer) {
        guard recorder.isRecording else { return }
        recorder.updateMeters()
        updateTimeClosure(recorder.currentTime.toHumanTime)
    }
    
    @objc private func updatePlayedTime(_ timer: Timer) {
        guard player.isPlaying else { return }
        updateTimeClosure(player.currentTime.toHumanTime)
    }
}

extension AudioRecorder: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playTimer.invalidate()
        endPlayingClosure()
    }
}








