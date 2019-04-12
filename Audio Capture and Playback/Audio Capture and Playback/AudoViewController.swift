//
//  AudoViewController.swift
//  Audio Capture and Playback
//
//  Created by Chris Rehagen on 4/9/19.
//  Copyright © 2019 Chris Rehagen. All rights reserved.
//

import UIKit
//import AVFoundation
import AVKit

class AudoViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var button1: UIBarButtonItem!
    @IBOutlet weak var button2: UIBarButtonItem!
    

    var recording = false
    var playing = false
    
    var audioSession: AVAudioSession? = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var audioFile: URL!
    

    
    let recordingSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
         AVEncoderBitRateKey: 16,
         AVNumberOfChannelsKey: 2,
         AVSampleRateKey: 44100.0] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.isEnabled = false
        button2.isEnabled = false
        
        
        
        audioSession!.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                self.button1.isEnabled = true
                self.button2.isEnabled = true
            }
            
        
        }
        
        
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
   
    @IBAction func recordAudio(_ sender: Any) {
        
        if !recording {
            do {
                recorder = try AVAudioRecorder(url: audioFile, settings: recordingSettings)
                recorder?.delegate = self
                recorder?.record()
                button1.image = UIImage(named: "stop")
                recording = true
                button2.isEnabled = false
            } catch {
                
            }
        } else {
            recording = false
            button1.image = UIImage(named: "record")
            button2.isEnabled = true
        }
    }

    @IBAction func playAudio(_ sender: Any) {
        if !playing {
            do {
                player = try AVAudioPlayer(contentsOf: audioFile, fileTypeHint: AVFileType.mp4.rawValue)
                player?.delegate = self as? AVAudioPlayerDelegate
                player?.prepareToPlay()
                player?.play()
                playing = true
                button2.image = UIImage(named: "stop")
                button1.isEnabled = false
            } catch {
                displayError(error.localizedDescription)
                print(error)
            }
        } else {
            playing = false
            player?.stop()
            player = nil
            button2.image = UIImage(named: "play")
            button1.isEnabled = true
        }
    }
    
}
    

    
    
    


