//
//  RainbowEgg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 12/3/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class RainbowEgg: Egg {
    
    var rainbowEggRunningTextures        = [SKTexture(imageNamed: "lgbt_0"),
                                            SKTexture(imageNamed: "lgbt_1")]
    var rainbowEggCrackedTextures        = [SKTexture(imageNamed: "lgbt_0"),
                                            SKTexture(imageNamed: "lgbt_1")]
    var rainbowEggDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                            SKTexture(imageNamed: "BE_death_anim_1"),
                                            SKTexture(imageNamed: "BE_death_anim_2"),
                                            SKTexture(imageNamed: "BE_death_anim_3"),
                                            SKTexture(imageNamed: "BE_death_anim_4")]
    var rainbowEggKickingTextures        = [SKTexture(imageNamed: "lgbt_0"),
                                            SKTexture(imageNamed: "lgbt_1")]
    var rainbowEggCrackedKickingTextures = [SKTexture(imageNamed: "lgbt_0"),
                                            SKTexture(imageNamed: "lgbt_1")]
    
    var rotationAction: SKAction!
    
    
    
    
    override init(sprite: SKSpriteNode, scene: GameScene) {
        super.init(sprite: sprite, scene: scene)
        
        self.eggRunningTextures = rainbowEggRunningTextures
        self.eggDeathTextures = rainbowEggDeathTextures
        self.eggCrackedTextures = rainbowEggRunningTextures
        self.eggKickingTextures = rainbowEggKickingTextures
        self.eggCrackedKickingTextures = rainbowEggCrackedKickingTextures
        
        self.baseSpeed = GameData.eggData.rainbowEgg.baseSpeed
        self.baseHealth = GameData.eggData.rainbowEgg.baseHealth
        self.baseDamage = GameData.eggData.rainbowEgg.baseDamage
        
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        
        self.coinRange = GameData.eggData.rainbowEgg.coinRange
        
        
        
        //        self.rotationAction = SKAction.run {
        //            self.sprite.zRotation -= GameData.eggData.rainbowEgg.constantRadianRotationRate
        //        }
        //        self.runAnimateAction = SKAction.repeatForever(SKAction.sequence([rotationAction, SKAction.wait(forDuration: 0.05)]))
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.04)
        self.animateAction = SKAction.repeatForever(runAnimateAction)
        
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.12)
        
        
        
    }
    
    override func addEgg() {
        self.sprite.name = "rainbowEgg"
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
