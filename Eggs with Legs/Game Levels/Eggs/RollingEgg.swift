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
    
    var rollingEggRunningTextures        = [SKTexture(imageNamed: "rolling_egg_0"),
                                            SKTexture(imageNamed: "rolling_egg_1"),
                                            SKTexture(imageNamed: "rolling_egg_2"),
                                            SKTexture(imageNamed: "rolling_egg_3"),
                                            SKTexture(imageNamed: "rolling_egg_4"),
                                            SKTexture(imageNamed: "rolling_egg_5"),
                                            SKTexture(imageNamed: "rolling_egg_6"),
                                            SKTexture(imageNamed: "rolling_egg_7"),
                                            SKTexture(imageNamed: "rolling_egg_8"),
                                            SKTexture(imageNamed: "rolling_egg_9"),
                                            SKTexture(imageNamed: "rolling_egg_10"),
                                            SKTexture(imageNamed: "rolling_egg_11"),
                                            SKTexture(imageNamed: "rolling_egg_12"),
                                            SKTexture(imageNamed: "rolling_egg_13"),
                                            SKTexture(imageNamed: "rolling_egg_14"),
                                            SKTexture(imageNamed: "rolling_egg_15")]
    var rollingEggCrackedTextures        = [SKTexture(imageNamed: "rolling_egg_0")]
    var rollingEggDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                            SKTexture(imageNamed: "BE_death_anim_1"),
                                            SKTexture(imageNamed: "BE_death_anim_2"),
                                            SKTexture(imageNamed: "BE_death_anim_3"),
                                            SKTexture(imageNamed: "BE_death_anim_4")]
    var rollingEggKickingTextures        = [SKTexture(imageNamed: "rolling_egg_0")]
    var rollingEggCrackedKickingTextures = [SKTexture(imageNamed: "rolling_egg_0")]
    
    var rotationAction: SKAction!
    
    
    
    
    override init(sprite: SKSpriteNode, scene: GameScene) {
        super.init(sprite: sprite, scene: scene)
        
        self.eggRunningTextures = rollingEggRunningTextures
        self.eggDeathTextures = rollingEggDeathTextures
        self.eggCrackedTextures = rollingEggRunningTextures
        self.eggKickingTextures = rollingEggKickingTextures
        self.eggCrackedKickingTextures = rollingEggCrackedKickingTextures
        
        self.baseSpeed = GameData.eggData.rollingEgg.baseSpeed
        self.baseHealth = GameData.eggData.rollingEgg.baseHealth
        self.baseDamage = GameData.eggData.rollingEgg.baseDamage
        
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        
        self.coinRange = GameData.eggData.rollingEgg.coinRange
        
        
        
//        self.rotationAction = SKAction.run {
//            self.sprite.zRotation -= GameData.eggData.rollingEgg.constantRadianRotationRate
//        }
//        self.runAnimateAction = SKAction.repeatForever(SKAction.sequence([rotationAction, SKAction.wait(forDuration: 0.05)]))
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.04)
        self.animateAction = SKAction.repeatForever(runAnimateAction)
        
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.12)
        
        
        
    }
    
    override func addEgg() {
        self.sprite.name = "RollingEgg"
        let actualY = random(min: self.sprite.size.height + 20, max: 600)
        self.sprite.position = CGPoint(x: (0 - self.sprite.size.width), y: actualY)
        self.sprite.zPosition = 2
        self.sprite.scale(to: CGSize(width: 120, height: 120))
        //gameScene.addChild(self.sprite)
        //gameScene.eggLayer.addChild(self.sprite)
         gameScene.addChild(self.sprite)
        gameScene.eggArrayNodes.append(self.sprite)
        self.runAnimate()
        gameScene.eggArray.append(self)
        
    }
    
    override func kickAnimate(fenceSprite: Fence) {
        
        fenceSprite.health -= Int(self.damage)
        GameData.stats.totalDamageTaken += self.damage

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
