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
    
    var basicEggRunningTextures        = [SKTexture(imageNamed: "BE_RA_0"),
                                           SKTexture(imageNamed: "BE_RA_1")]
    var basicEggCrackedTextures        = [SKTexture(imageNamed: "BE_cracked_anim_0"),
                                           SKTexture(imageNamed: "BE_cracked_anim_1")]
    var basicEggDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                           SKTexture(imageNamed: "BE_death_anim_1"),
                                           SKTexture(imageNamed: "BE_death_anim_2"),
                                           SKTexture(imageNamed: "BE_death_anim_3"),
                                           SKTexture(imageNamed: "BE_death_anim_4")]
    var basicEggKickingTextures        = [SKTexture(imageNamed: "egg_11"),
                                           SKTexture(imageNamed: "egg_22")]
    var basicEggCrackedKickingTextures = [SKTexture(imageNamed: "egg33"),
                                           SKTexture(imageNamed: "egg44")]
    
    
    //var anim: SKAction
    
    
    override init(sprite: SKSpriteNode) {
        super.init(sprite: sprite)
        
        self.eggRunningTextures = basicEggRunningTextures
        self.eggDeathTextures = basicEggDeathTextures
        self.eggCrackedTextures = basicEggCrackedTextures
        self.eggKickingTextures = basicEggKickingTextures
        self.eggCrackedKickingTextures = basicEggCrackedKickingTextures
        
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.25)
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.25)
        self.crackedAnimateAction = SKAction.animate(with: self.eggCrackedTextures, timePerFrame: 0.25)
        self.kickingAnimateAction = SKAction.animate(with: self.eggKickingTextures, timePerFrame: 0.25)
        //make this a sequence
        self.crackedKickingAnimateAction = SKAction.animate(with: self.eggCrackedKickingTextures , timePerFrame: 0.25)
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
