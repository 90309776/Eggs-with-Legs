//
//  Sound.swift
//  Eggs with Legs
//
//  Created by 90304593 on 11/29/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    var playStuff: AVAudioPlayer?
    var playStuffToo: AVAudioPlayer?
    var player: Player!
    
    func playSound(SoundName: String) {
        let path = Bundle.main.path(forResource: SoundName, ofType : "wav")!
        let url = URL(fileURLWithPath : path)
        
        do {
            print("yoyoyooyoyo")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("4Head")
        }
        
        do {
            print("asdjoskljfslkdfj")
            playStuff = try AVAudioPlayer(contentsOf: url)
            playStuff?.play()
        } catch {
            print ("Something's gone terribly wrong")
        }
    }
    
    func musicLoop(SoundName: String) {
        
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: SoundName, ofType: "wav")!)
        
        do {
            print("yoyoyooyoyo")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("4Head")
        }
        
        
        playStuffToo = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        playStuffToo!.prepareToPlay()
        playStuffToo!.numberOfLoops = -1
        playStuffToo!.play()
    }
    func stopMusic(){
        if (playStuffToo?.isPlaying ?? false){
            playStuffToo!.stop()
        }
    }
}
