//
//  SoundManager.swift
//  GameFlipCard
//
//  Created by Nguyen Duy anh on 2/5/20.
//  Copyright © 2020 Nguyen Duy anh. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect: SoundEffect) {
        var soundFilename = ""
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
            
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        } catch {
            print("Couldn't create the audio player object for sound file, \(soundFilename)")
        }
    }
}
