//
//  RussianEgg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 12/3/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

class RussianEgg: BasicEgg {
    
    var spawnCountdown: Int
    
    override init(sprite: SKSpriteNode, scene: GameScene) {
        self.spawnCountdown = GameData.eggData.russianEgg.spawnAmount
        
        
        super.init(sprite: sprite, scene: scene)
        
        //self.sprite.name = "RussianEgg"
        //self.sprite.scale(to: CGSize(width: 300, height: 300))
        
        self.baseSpeed = GameData.eggData.russianEgg.baseSpeed
        self.baseHealth = GameData.eggData.russianEgg.baseHealth
        self.baseDamage = GameData.eggData.russianEgg.baseDamage
        
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        
        print("new russian")
    }
    
    override func addEgg() {
        
        
        self.sprite.name = "RussianEgg"
        //let actualY = random(min: 0 - gameScene.size.height / 2 + self.sprite.size.height, max: 275)
        let actualY = random(min: self.sprite.size.height + 100, max: 600)
        self.sprite.position = CGPoint(x: (0 - self.sprite.size.width), y: actualY)
        self.sprite.zPosition = 2
        self.sprite.scale(to: CGSize(width: 300, height: 300))
        self.runAnimate()
        print("hey")
        
        
        //gameScene.eggLayer.addChild(self.sprite)
        gameScene.addChild(self.sprite)
        gameScene.eggArrayNodes.append(self.sprite)
        gameScene.eggArray.append(self)
        
    }
    
    func spawnBabies() {
        if spawnCountdown > 0 {
            addBabies()
            self.spawnCountdown -= 1
        }
        
    }
    
    override func addBabies() {
        
        print("babies")
        //let actualY = random(min: 0 - gameScene.size.height / 2 + self.sprite.size.height, max: 275)
        var baby = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"), scene: self.gameScene)
        var ranXDisplacement = Int.random(in: -80..<(-30))
        var ranYDisplacement = generateRanYDisplacement()
        
        //let actualY = random(min: self.sprite.size.height + 20, max: 600)
        baby.sprite.position = CGPoint(x: self.sprite.position.x + CGFloat(ranXDisplacement), y: self.sprite.position.y + CGFloat(ranYDisplacement))
        baby.sprite.zPosition = 2
        baby.sprite.scale(to: CGSize(width: 90, height: 90))
        baby.runAnimate()
        
        baby.health = self.health / 2
        baby.speed = self.speed / 1.2
        
        
        
        
        //gameScene.eggLayer.addChild(self.sprite)
        gameScene.addChild(baby.sprite)
        gameScene.eggArrayNodes.append(baby.sprite)
        gameScene.eggArray.append(baby)
    }
    
    func generateRanYDisplacement() -> Int {
        let max: CGFloat = 600
        let min: CGFloat = 0
        
        let momY = self.sprite.position.y
        
        let momYMaxRange = abs(max - momY)
        let momYMinRange = abs(min - momY)
        
        let spawnRange = [-200, 200]
        
        let ranYDisplacement = Int.random(in: spawnRange[0]..<spawnRange[1])
        if (ranYDisplacement < 0) {
            if (momY + CGFloat(ranYDisplacement) < 0 + 90) { //gonna always be subtracting cuz its negative
                self.generateRanYDisplacement() //recursively call itself to try again
            }
        } else { //its greater than 0
            if (momY + CGFloat(ranYDisplacement) > 600 - 90) {
                self.generateRanYDisplacement() //recursively call itself to try again
            }
        }
        
        return ranYDisplacement
        
        
    }
    
    
}
