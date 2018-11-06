//
//  Player.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/29/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

//class handles the cooldown for tapping

class Player {
    
    
    //Variables referenced are public variables from GameData class
    
    var weaponSprite: SKSpriteNode!
    var maxTapCount = GameData.playerData.maxTapCount
    var currentTapCount: Int
    //var cooldownInterval = GameData.playerData.cooldownInterval
    var cooldownInterval: TimeInterval = 1.2
    var canFire = true
    
    var weaponFireTextures = [SKTexture(imageNamed: "player_weapon_fire_0"),
                              SKTexture(imageNamed: "player_weapon_fire_1"),
                              SKTexture(imageNamed: "player_weapon_fire_2"),
                              SKTexture(imageNamed: "player_weapon_fire_3")]
    
    var weaponReloadTextures = [SKTexture(imageNamed: "player_weapon_reload_0"),
                                SKTexture(imageNamed: "player_weapon_reload_1"),
                                SKTexture(imageNamed: "player_weapon_reload_2"),
                                SKTexture(imageNamed: "player_weapon_reload_3"),
                                SKTexture(imageNamed: "player_weapon_reload_3"),
                                SKTexture(imageNamed: "player_weapon_reload_0")]
    
    var weaponFireAnimation: SKAction!
    var weaponReloadAnimation: SKAction!
    
    var isReloading = false
    
    init(sprite: SKSpriteNode) {
        self.currentTapCount = self.maxTapCount
        self.weaponSprite = sprite
        
        self.weaponFireAnimation = SKAction.animate(with: weaponFireTextures, timePerFrame: 0.10)
        self.weaponReloadAnimation = SKAction.animate(with: weaponReloadTextures, timePerFrame: 0.20)
        
    }
    
    func tapped() {
        if currentTapCount > 0 && canFire {
            self.currentTapCount -= 1
            animateFire()
        }
    }
    
    func animateFire() {
        self.weaponSprite.run(weaponFireAnimation)
    }
    
    func animateCooldown() {
       // print("called")
        func toggleCanFire() {
            self.canFire = true
            self.currentTapCount = GameData.playerData.maxTapCount
            //print("ran")
        }
       
        canFire = false
        let runSequence = SKAction.sequence([weaponReloadAnimation, SKAction.wait(forDuration: self.cooldownInterval), SKAction.run(
                toggleCanFire)])
        self.weaponSprite.run(runSequence)
        
    }
    
    func update() {
        if self.currentTapCount == 0 && canFire {
            animateCooldown()
        }
    }
}
