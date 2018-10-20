//
//  Projectile.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/15/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation


/*
 This projectile is spawns through the tower class.
 The projectile is given a target position to travel to.
 
 */

class Projectile {
    
    var sprite: SKSpriteNode!
    //var startPos: CGPoint
    var targetPos: CGPoint
    //var startPos: CGPoint
    
    init(startPos: CGPoint, targetPos: CGPoint, type: String) {
        if type == "projectile" {
            self.sprite = SKSpriteNode(imageNamed: "projectile")
            self.sprite.position = startPos
            self.sprite.zRotation = 0.0
        }
        
        
        //Defining a projectile's physics properties and hitboxes
        self.targetPos = targetPos
        self.sprite.name = "projectile"
        //self.sprite.physicsBody = SKPhysicsBody(texture: self.sprite.texture!, size: CGSize(width: self.sprite.size.width, height: self.sprite.size.height))
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        self.sprite.physicsBody?.isDynamic          = true // 2
        self.sprite.physicsBody?.affectedByGravity  = false
        self.sprite.physicsBody?.mass = 10000
        //self.sprite.physicsBody.dam
        self.sprite.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.projectile
        //self.sprite.physicsBody?.collisionBitMask = GameScene.PhysicsCategory.egg
        self.sprite.physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.egg
    }
    //        let actioove = SKAction.move(to: CGPoint(x: egg.size.width + size.width, y: actualY), duration: TimeInterval(speed))
    
    func projectileShootLinear() {
        let actionMove = SKAction.move(to: self.targetPos, duration: 0.25)
        self.sprite.run(actionMove)
    }
    
    func projectileShootArch() {
        
    }
    
    
}