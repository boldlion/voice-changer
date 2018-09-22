//
//  RecordViewController
//  VoiceChanger
//
//  Created by Bold Lion on 21.09.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecoder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar {
            bar.isHidden = true
        }
        stopRecordButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        recordLabel.text = "Record in progress"
        stopRecordButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordingVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecoder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecoder.delegate = self
        audioRecoder.isMeteringEnabled = true
        audioRecoder.prepareToRecord()
        audioRecoder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordLabel.text = "Tap to record"
        stopRecordButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecoder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPitchViewController" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioUrl = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioUrl
        }
    }
}

extension RecordViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "segueToPitchViewController", sender: audioRecoder.url)
        }
        else {
            let alert = UIAlertController(title: "Something went wrong!", message: "Try to record that again, please", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
