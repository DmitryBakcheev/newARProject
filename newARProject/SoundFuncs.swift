//
//  SoundFuncs.swift
//  newARProject
//
//  Created by Дмитрий Бакчеев on 8/8/22.
//

import UIKit
import SceneKit
import ARKit






extension ViewController {

    
    
//    This func takes in two parameters — “sound” and “format”. You need to call the function like this:
//    playSound(sound: "explosion", format: "mp3")
    
    func playSound(sound : String, format: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: format) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
//    This func is for background music. You need to call this func in viewDidLoad
    
    func playBackgroundMusic(to rootNode: SCNNode){
        let audioNode = SCNNode()
        let audioSource = SCNAudioSource(fileNamed: "harmony.mp3")!
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        
        audioNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
        audioNode.runAction(play)
        rootNode.addChildNode(audioNode)
    }
}


