//
//  PlaySoundViewController.swift
//  VoiceChanger
//
//  Created by Bold Lion on 21.09.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var recordedAudioURL: URL!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchedButton: UIButton!
    @IBOutlet weak var lowPitchedButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recorderAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int { case slow = 0, fast, highPitched, lowPitched, echo, reverb }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar {
            bar.isHidden = false
            bar.setBackgroundImage(UIImage(), for: .default)
            bar.tintColor = UIColor(red: 1/255, green: 103/255, blue: 95/255, alpha: 1)
            bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            bar.shadowImage = UIImage()
        }
        setImagesForButtons()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let bar = navigationController?.navigationBar {
            bar.isHidden = true
            stopAudio()
        }
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitched:
            playSound(pitch: 1000)
        case .lowPitched:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        stopAudio()
    }
    
    // MARK: Set the images for each button
    fileprivate func setImagesForButtons() {
        setButtonImages(button: slowButton)
        setButtonImages(button: fastButton)
        setButtonImages(button: highPitchedButton)
        setButtonImages(button: lowPitchedButton)
        setButtonImages(button: echoButton)
        setButtonImages(button: reverbButton)
    }
    
    // MARK: Small screen devices' (5S/SE) landscape orienation won't look good without this!
    fileprivate func setButtonImages(button: UIButton  ) {
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
    }
    
}
