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
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        self.sprite.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.fence // 3
        self.sprite.physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.egg // 4
        self.sprite.physicsBody?.collisionBitMask = GameScene.PhysicsCategory.egg // 5
    }
    
}
