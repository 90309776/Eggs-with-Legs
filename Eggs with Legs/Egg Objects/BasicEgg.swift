//
//  BasicEgg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/8/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

/*
 This class inheirits the main Egg class. This class is a subclass of the main
 Egg giving the subclass type specific attributes that other Egg types don't have.
 
 Contains functions that will override the main Egg class functions when there is a
 specific egg of this subclass instructed to be created.
 
 EGG
    BasicEgg
    RollingEgg
 
 */


class BasicEgg: Egg {
    
    var basicEggRunningAnimation    = [SKTexture(imageNamed: "BE_RA_0"),
                                       SKTexture(imageNamed: "BE_RA_1")]
    var basicEggDeathAnimation      = [SKTexture(imageNamed: "BE_deathAnimation_0"),
                                       SKTexture(imageNamed: "BE_deathAnimation_1"),
                                       SKTexture(imageNamed: "BE_deathAnimation_2"),
                                       SKTexture(imageNamed: "BE_deathAnimation_3")]
    
    
    //var anim: SKAction
    
    
    override init(sprite: SKSpriteNode) {
        super.init(sprite: sprite)
        
        self.eggRunningTextures = basicEggRunningAnimation
        self.eggDeathTextures = basicEggDeathAnimation
        
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.25)
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.25)
        self.animateAction = SKAction.repeatForever(runAnimateAction)
        
    }
    
    
//    override func animate() {
//        if self.health == 0 {
//    }
        
//        if self.health == 10 {
//            self.sprite.run(animateAction)
//            print("animtaitng")
//
//        }
//        if self.animationCount == 7 {
//            self.sprite.texture = self.basicEggRunningAnimation[0]
//        } else if animationCount == 14  {
//            self.animationCount = 0
//            self.sprite.texture = self.basicEggRunningAnimation[1]
//        }
    
    
//    override func deathAnimation() {
//        if self.animationCount == 0 {
//            self.sprite.texture = self.basicEggDeathAnimation[0]
//        } else if animationCount == 4  {
//            self.sprite.texture = self.basicEggDeathAnimation[1]
//        } else if animationCount == 8  {
//            self.sprite.texture = self.basicEggDeathAnimation[2]
//        } else if animationCount == 12  {
//            self.sprite.texture = self.basicEggDeathAnimation[3]
//        } else if animationCount == 30 {
//            self.sprite.removeFromParent()
//        }
//    }
    
    
}
