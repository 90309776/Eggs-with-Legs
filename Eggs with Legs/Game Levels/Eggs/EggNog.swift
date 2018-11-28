//
//  Rooster.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/31/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class EggNog: Egg {
    
    var eggNogRunningTextures        = [SKTexture(imageNamed: "eggnog_0"),
                                            SKTexture(imageNamed: "eggnog_1"),
                                            SKTexture(imageNamed: "eggnog_2")]
    var eggNogCrackedTextures        = [SKTexture(imageNamed: "eggnog_0"),
                                        SKTexture(imageNamed: "eggnog_1"),
                                        SKTexture(imageNamed: "eggnog_2")]
    var eggNogDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                            SKTexture(imageNamed: "BE_death_anim_1"),
                                            SKTexture(imageNamed: "BE_death_anim_2"),
                                            SKTexture(imageNamed: "BE_death_anim_3"),
                                            SKTexture(imageNamed: "BE_death_anim_4")]
    var eggNogKickingTextures        = [SKTexture(imageNamed: "eggnog_0"),
                                        SKTexture(imageNamed: "eggnog_1"),
                                        SKTexture(imageNamed: "eggnog_2")]
    var eggNogCrackedKickingTextures = [SKTexture(imageNamed: "eggnog_0"),
                                        SKTexture(imageNamed: "eggnog_1"),
                                        SKTexture(imageNamed: "eggnog_2")]
    
    
    override init(sprite: SKSpriteNode, scene: GameScene) {
        super.init(sprite: sprite, scene: scene)
        
        self.eggRunningTextures = eggNogRunningTextures
        self.eggDeathTextures = eggNogDeathTextures
        self.eggCrackedTextures = eggNogRunningTextures
        self.eggKickingTextures = eggNogKickingTextures
        self.eggCrackedKickingTextures = eggNogCrackedKickingTextures
        
        self.baseSpeed = GameData.eggData.eggNog.baseSpeed
        self.baseHealth = GameData.eggData.eggNog.baseHealth
        self.baseDamage = GameData.eggData.eggNog.baseDamage
        
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        
        self.coinRange = GameData.eggData.eggNog.coinRange
       
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.17)
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.12)
        self.crackedAnimateAction = SKAction.animate(with: self.eggCrackedTextures, timePerFrame: 0.17)
        self.kickingAnimateAction = SKAction.animate(with: self.eggKickingTextures, timePerFrame: 0.17)
        self.crackedKickingAnimateAction = SKAction.animate(with: self.eggCrackedKickingTextures , timePerFrame: 0.25)
        self.animateAction = SKAction.repeatForever(runAnimateAction)
        
    }
    
    override func addEgg() {
        self.sprite.name = "EggNog"
        //let actualY = random(min: 0 - gameScene.size.height / 2 + self.sprite.size.height, max: 275)
        let actualY = random(min: self.sprite.size.height + 20, max: 600)
        self.sprite.position = CGPoint(x: (0 - self.sprite.size.width), y: actualY)
        self.sprite.zPosition = 2
        self.sprite.scale(to: CGSize(width: 80, height: 200))
        self.runAnimate()
        
        gameScene.addChild(self.sprite)
        //gameScene.eggLayer.addChild(self.sprite)
        gameScene.eggArrayNodes.append(self.sprite)
        gameScene.eggArray.append(self)
        
    }
    
}


