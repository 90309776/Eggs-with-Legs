//
//  Fence.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/8/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class Fence {
    
    var sprite: SKSpriteNode
    var baseHealth = GameData.fenceData.baseHealth
    var health: Int
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        self.health = self.baseHealth * GameData.fenceData.healthMultiplier
        
        self.sprite.physicsBody?.categoryBitMask = GameData.PhysicsCategory.fence // 3
        self.sprite.physicsBody?.contactTestBitMask = GameData.PhysicsCategory.egg // 4
        self.sprite.physicsBody?.collisionBitMask = GameData.PhysicsCategory.egg // 5
    }
    
    func changeSprite() {
        
    }
    
    func update() {
        if (self.health <= 0) {
            //self.sprite.removeFromParent()
            self.sprite.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.none // 3
            self.sprite.physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.none
            self.sprite.physicsBody?.collisionBitMask = GameScene.PhysicsCategory.none
            
        }
    }
}
