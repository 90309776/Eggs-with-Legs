//
//  Egg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/7/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

/*
 The main parent class for all subclasses for Egg
 Contains all atributes that all eggs must have and functions that
 all eggs will be able to use.
 
 Most eggs created will be created through a subclass of this Egg class
 
 */

class Egg {
    
    var sprite:     SKSpriteNode
    
    var baseSpeed:  Double = GameData.eggData.basicEgg.baseSpeed
    var speed:      Double
    
    var baseHealth: Double = GameData.eggData.basicEgg.baseHealth
    var health:     Double
    var maxhealth:  Double
    
    var baseDamage: Int = GameData.eggData.basicEgg.baseDamage
    var damage:     Int
    
    var hasContactProjectile: Bool
    var shownHealthBar: Bool
    var coinRange: [Int] //2 Ints: [min, max]
    
    var notAlive = false
    
    //ANIMATIION VARIABLES
    var animationState:       String
    var animateAction:        SKAction!
    var runAnimateAction:     SKAction!
    var deathAnimateAction:   SKAction!
    var crackedAnimateAction: SKAction!
    var kickingAnimateAction: SKAction!
    var crackedKickingAnimateAction: SKAction!
    
    
    var eggRunningTextures: [SKTexture]!
    var eggDeathTextures:   [SKTexture]!
    var eggCrackedTextures: [SKTexture]!
    var eggKickingTextures: [SKTexture]!
    var eggCrackedKickingTextures: [SKTexture]!
    
    var hasContactFence: Bool
    
    var healthBar: Bar
    
    var gameScene: GameScene!
    
    init(sprite: SKSpriteNode, scene: GameScene) {
        self.sprite = sprite
        self.gameScene = scene
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        self.shownHealthBar = false
        //self.animateType = 0
        self.hasContactProjectile = false
        
        self.hasContactFence = false
        //self.scene = scene
        //self.animationCount = 0
        self.coinRange = [0, 0] // value is set through child class
        //gameScene.addChild(self.sprite)
        self.animationState = "running"
        
        self.healthBar = Bar(eggSprite: self.sprite, scene: gameScene, size: CGSize(width: 100, height: 30))
        self.sprite.addChild(healthBar.barBorder)
        self.sprite.addChild(healthBar.bar)
        self.healthBar.barBorder.isHidden = true
        self.healthBar.bar.isHidden = true
        /*
         Gives every Egg type physics properties
        */
        self.sprite.physicsBody = SKPhysicsBody(texture: self.sprite.texture!, size: CGSize(width: self.sprite.size.width, height: self.sprite.size.height))
        self.sprite.physicsBody?.isDynamic          = true // 2
        self.sprite.physicsBody?.affectedByGravity  = false
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.categoryBitMask    = GameData.PhysicsCategory.egg // 3
        self.sprite.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.fence
                                                    //| GameScene.PhysicsCategory.projectile
        self.sprite.physicsBody?.collisionBitMask   = GameData.PhysicsCategory.fence
                                                    //| GameScene.PhysicsCategory.egg // 5
                                                    //| GameScene.PhysicsCategory.projectile
    }
    
    func move() {
        self.sprite.position.x += CGFloat(self.speed)
        updateHealthBar()
    }
    
    //animate and deathAnamation should be overriden by their subclasses when called
    //These are place holder functions so Swift stays happy
    func runAnimate() {
        //print("i dont have anyhting to animate")
        self.sprite.removeAllActions()
        self.animateAction = SKAction.repeatForever(self.runAnimateAction)
        self.sprite.run(self.animateAction, withKey: "run")
        self.animationState = "running"
    }
    
    func addEgg() {
        //Function is overriden by the respective child class
        //print("ye")
    }
    
    func checkCrackedRunAnimate() {
        if self.health < self.maxhealth  - 1 && self.animationState != "cracked_running" && self.animationState != "kicking" && self.animationState != "cracked_kicking"{
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeatForever(self.crackedAnimateAction)
            self.sprite.run(self.animateAction, withKey: "cracked_run")
            self.animationState = "cracked_running"
        }
    }
    
    func checkDeathAnimate(index: Int) {
        if self.health <= 0.0 && self.animationState != "death" {
            //gameScene.eggCount += 1
            self.healthBar.bar.size.width = 0
            self.sprite.removeAllActions()
            self.sprite.zRotation = 0
            
            self.animateAction = SKAction.repeat(self.deathAnimateAction, count: 1)
            self.sprite.run(SKAction.sequence([self.animateAction, SKAction.removeFromParent()]), withKey: "death")
            self.animationState = "death"
            self.addCoins()
            gameScene.eggCount += 1
            
            let currentEggCount = UserDefaults.standard.value(forKey: "eggscracked") as! Int
            UserDefaults.standard.set(currentEggCount + 1, forKey: "eggscracked")
            //gameScene.eggsCracked += 1
            GameData.stats.totalEggsCracked += 1
            self.notAlive = true
            if gameScene.eggArray.count > index {
                //gameScene.eggArray.remove(at: index)
                //gameScene.eggArrayNodes.remove(at: index)
            }
        }
    }
    
    
    
    func kickAnimate(fenceSprite: Fence) {
        //print("\(self.animationState)")
        
        func decreaseFenceHealth() {
            fenceSprite.health -= Int(self.damage)
            GameData.stats.totalDamageTaken += self.damage
        }
        
        if self.animationState == "running" {
            self.sprite.removeAllActions()
            //self.animateAction = SKAction.repeatForever(self.kickingAnimateAction)
            self.animateAction = SKAction.repeatForever(SKAction.sequence([self.kickingAnimateAction, SKAction.run(decreaseFenceHealth), SKAction.wait(forDuration: 3)]))
            self.sprite.run(self.animateAction)
            self.animationState = "kicking"
            //self.sprite.name = "basicegg"
        } else if self.animationState == "cracked_running"  {
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeatForever(SKAction.sequence([self.crackedKickingAnimateAction, SKAction.run(decreaseFenceHealth), SKAction.wait(forDuration: 3)]))
            self.sprite.run(self.animateAction)
            self.animationState = "cracked_kicking"
            //self.sprite.name = "basicegg now"
        }
        
        
        
    }
    
    func checkCrackedKickAnimate(fenceSprite: Fence) {
        
        if self.animationState == "kicking"  && self.health < self.maxhealth{
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeatForever(SKAction.sequence([self.crackedKickingAnimateAction, SKAction.run({fenceSprite.health -= Int(self.damage)}), SKAction.wait(forDuration: 3)]))
            self.sprite.run(self.animateAction)
            self.animationState = "cracked_kicking"
            //self.sprite.name = "basicegg now"
        }
    }
    
    func addBabies() {
        //filler
    }
    
    func checkShowHealthBar() {
        if (self.health <= self.maxhealth - 1 && !self.shownHealthBar) {
            self.healthBar.barBorder.isHidden = false
            self.healthBar.bar.isHidden = false
        }
    }
    
    func addCoins() {
        let randomCoinAmount = Int.random(in: coinRange[0]..<coinRange[1])
        GameData.playerData.coins += randomCoinAmount
    }
    
    func updateHealthBar() {
        let healthPercentage = self.health / self.maxhealth
        let healthBarWidth = Double(healthBar.barMaxWidth) * healthPercentage
        self.healthBar.bar.size = CGSize(width: healthBarWidth, height: 20)
        //self.healthBar.healthBar.position.x = self.healthBar.healthBar.position.x - CGFloat(healthBarWidth)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
