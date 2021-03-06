//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by howard.lee on 7/20/15.
//  Copyright (c) 2015 howard.lee. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: AudioModel!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        if var url = receivedAudio.filePathUrl {
            audioFile = AVAudioFile(forReading: url, error: nil)
            audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
            audioPlayer.enableRate = true;
        } else {
            println("audio resource not found!")
        }
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowlyTapped(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playQuicklyTapped(sender: UIButton) {
        playAudioWithRate(1.5)
    }

    @IBAction func playChipmunkTapped(sender: UIButton) {
        playAudioWithPitch(1000)
    }

    @IBAction func playDarthVaderTapped(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    func playAudioWithRate(rate: Float) {
        stopAndResetAudioPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
    }

    func playAudioWithPitch(pitch: Float) {
        stopAndResetAudioPlayer()

        var audioNode: AVAudioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioNode)
        var audioTimePitch: AVAudioUnitTimePitch = AVAudioUnitTimePitch()
        audioTimePitch.pitch = pitch
        audioEngine.attachNode(audioTimePitch)

        audioEngine.connect(audioNode, to: audioTimePitch, format: nil)
        audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)

        audioNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioNode.play()
    }

    @IBAction func stopAudio(sender: AnyObject) {
        stopAndResetAudioPlayer()
    }

    func stopAndResetAudioPlayer() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
}
