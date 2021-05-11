//
//  Player.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/29/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

import AVFoundation


import AudioToolbox

//class handles the cooldown for tapping

class Player {
    //Variables referenced are public variables from GameData class
    
    var playStuff: AVAudioPlayer?
    
    var weaponSprite: SKSpriteNode!
    var maxTapCount = GameData.playerData.maxTapCount
    var currentTapCount: Int
    //var cooldownInterval = GameData.playerData.cooldownInterval
    var cooldownInterval: TimeInterval = 0.2
    var canTap = true
    
    var tapBar: Bar!
    
    
    var weaponFireTextures = [SKTexture(imageNamed: "player_weapon_fire_0"),
                              SKTexture(imageNamed: "player_weapon_fire_1"),
                              SKTexture(imageNamed: "player_weapon_fire_2"),
                              SKTexture(imageNamed: "player_weapon_fire_3")]
    
    var weaponReloadTextures = [SKTexture(imageNamed: "player_weapon_reload_0"),
                                SKTexture(imageNamed: "player_weapon_reload_1"),
                                SKTexture(imageNamed: "player_weapon_reload_2"),
                                SKTexture(imageNamed: "player_weapon_reload_3"),
                                SKTexture(imageNamed: "player_weapon_reload_4"),

                                SKTexture(imageNamed: "player_weapon_reload_0"),
                                SKTexture(imageNamed: "player_weapon_reload_0"), //"Pauses" to fit with reload sound
                                SKTexture(imageNamed: "player_weapon_reload_0"),
                                SKTexture(imageNamed: "player_weapon_reload_4"),

                                SKTexture(imageNamed: "player_weapon_reload_0")]
    
    var weaponFireAnimation: SKAction!
    var weaponReloadAnimation: SKAction!
    
    var isReloading = false
    
    init() {
        self.currentTapCount = self.maxTapCount
        //self.weaponSprite = sprite
        
        self.tapBar = Bar(size: CGSize(width: 300, height: 100))
        self.tapBar.bar.size.width = 0
        self.tapBar.barBorder.position = CGPoint(x: GameData.sceneScaling.playableArea.maxX - 200, y: GameData.sceneScaling.playableArea.maxY - 75)
        
        self.weaponFireAnimation = SKAction.animate(with: weaponFireTextures, timePerFrame: 0.10)
        self.weaponReloadAnimation = SKAction.animate(with: weaponReloadTextures, timePerFrame: 0.20)
        
    }
    
    func tapped() {
        if  self.canTap {
            //self.currentTapCount -= 1
            //animateFire()
            self.tapBar.bar.size.width += CGFloat(self.tapBar.barMaxWidth) * CGFloat(GameData.playerData.tapBarIncreaseRate)
        }
    }
    
    func animateFire() {
        self.weaponSprite.run(weaponFireAnimation)
    }
    
    func animateCooldown() {
       // print("called")
        func togglecanTap() {
            self.canTap = true
            self.currentTapCount = GameData.playerData.maxTapCount
        }
        if self.canTap {
            canTap = false
            if GameData.settingsData.vibration {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            //playSound(SoundName: "GunFullReload")
            let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.15)
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.15)
            self.tapBar.bar.color = UIColor.red
            
            let normalDepletionRate = GameData.playerData.tapBarDepletionRate
            let coolDownDepletionRate = normalDepletionRate + 0.004
            
            GameData.playerData.tapBarDepletionRate = coolDownDepletionRate
            
            let blinkingSequence = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
            self.tapBar.bar.run(blinkingSequence, withKey: "blinking")
            
            let coolDownSequence = SKAction.sequence([ SKAction.wait(forDuration: 3.0), SKAction.run {
                self.canTap = true
                self.tapBar.bar.color = UIColor.black
                self.tapBar.bar.removeAction(forKey: "blinking")
                GameData.playerData.tapBarDepletionRate = normalDepletionRate
                }])
            self.tapBar.bar.run(coolDownSequence)
            
        }
        
        
    }
    
    func update() {
        if self.tapBar.bar.size.width >= CGFloat(self.tapBar.barMaxWidth) && canTap {
            animateCooldown()
            print("graeter")
        } else if self.tapBar.bar.size.width >= 0 {
            self.tapBar.bar.size.width -= (CGFloat(self.tapBar.barMaxWidth) * CGFloat(GameData.playerData.tapBarDepletionRate))
        }
        
        if !self.canTap && self.tapBar.bar.size.width < CGFloat(10) {
            self.canTap = true
            //self.tapBar.bar.removeAction(forKey: "blinking")
            self.tapBar.bar.color = UIColor.black
            
        }
        
    }
    
    func playSound(SoundName: String) {
        
        let path = Bundle.main.path(forResource: SoundName, ofType : "wav")!
        
        let url = URL(fileURLWithPath : path)
  
        do {
            
            playStuff = try AVAudioPlayer(contentsOf: url)
            
            playStuff?.play()
     
        } catch {
 
            print ("Something's gone terribly wrong")
   
        }
        
    }

}
