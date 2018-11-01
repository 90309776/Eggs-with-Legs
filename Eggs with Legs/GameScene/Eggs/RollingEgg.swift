//
//  RollingEgg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/8/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation
//dont forget to set defaults

class RollingEgg: Egg {
    
    var rollingEggRunningTextures        = [SKTexture(imageNamed: "rolling_egg_0")]
    var rollingEggCrackedTextures        = [SKTexture(imageNamed: "rolling_egg_0")]
    var rollingEggDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                            SKTexture(imageNamed: "BE_death_anim_1"),
                                            SKTexture(imageNamed: "BE_death_anim_2"),
                                            SKTexture(imageNamed: "BE_death_anim_3"),
                                            SKTexture(imageNamed: "BE_death_anim_4")]
    var rollingEggKickingTextures        = [SKTexture(imageNamed: "rolling_egg_0")]
    var rollingEggCrackedKickingTextures = [SKTexture(imageNamed: "rolling_egg_0")]
    
    var rotationAction: SKAction!
    
    
    
    
    override init(sprite: SKSpriteNode) {
        super.init(sprite: sprite)
        
        self.eggRunningTextures = rollingEggRunningTextures
        self.eggDeathTextures = rollingEggDeathTextures
        self.eggCrackedTextures = rollingEggCrackedTextures
        self.eggKickingTextures = rollingEggKickingTextures
        self.eggCrackedKickingTextures = rollingEggCrackedKickingTextures
        
        self.baseSpeed = GameData.eggData.rollingEgg.baseSpeed
        self.baseHealth = GameData.eggData.rollingEgg.baseHealth
        self.baseDamage = GameData.eggData.rollingEgg.baseDamage
        
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        
        self.rotationAction = SKAction.run {
            self.sprite.zRotation -= GameData.eggData.rollingEgg.constantRadianRotationRate
        }
        self.runAnimateAction = SKAction.repeatForever(SKAction.sequence([rotationAction, SKAction.wait(forDuration: 0.05)]))
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.12)
        
    }
    
    override func addEgg() {
        self.sprite.name = "RollingEgg"
        let actualY = random(min: 0 - gameScene.size.height / 2 + self.sprite.size.height, max: 275)
        self.sprite.position = CGPoint(x: (0 - (gameScene.size.width / 2) - self.sprite.size.width), y: actualY)
        self.sprite.scale(to: CGSize(width: 300, height: 300))
        //gameScene.addChild(self.sprite)
        self.runAnimate()
        gameScene.eggArray.append(self)
         print("sssss")
    }
    
    override func kickAnimate(fenceSprite: Fence) {
        
        fenceSprite.health -= self.damage
        
        self.health = 0
        for (index, egg) in gameScene.eggArray.enumerated() {
            if egg.sprite == self.sprite {
                self.checkDeathAnimate(index: index)
            }
        }
    }
    
    override func checkCrackedKickAnimate(fenceSprite: Fence) {
        
    }
    
    override func checkCrackedRunAnimate() {
        
    }
    
    
}
