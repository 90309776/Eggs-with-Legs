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
//    var basicEggRunningTextures        = [SKTexture(imageNamed: "rollingblade_0"),
//                                          SKTexture(imageNamed: "rollingblade_1")]
    var basicEggCrackedTextures        = [SKTexture(imageNamed: "BE_cracked_anim_0"),
                                           SKTexture(imageNamed: "BE_cracked_anim_1")]
    var basicEggDeathTextures          = [SKTexture(imageNamed: "BE_death_anim_0"),
                                           SKTexture(imageNamed: "BE_death_anim_1"),
                                           SKTexture(imageNamed: "BE_death_anim_2"),
                                           SKTexture(imageNamed: "BE_death_anim_3"),
                                           SKTexture(imageNamed: "BE_death_anim_4")]
    var basicEggKickingTextures        = [SKTexture(imageNamed: "egg_kick_white0"),
                                          SKTexture(imageNamed: "egg_kick_white1"),
                                          SKTexture(imageNamed: "egg_kick_white2"),
                                          SKTexture(imageNamed: "egg_kick_white3"),
                                          SKTexture(imageNamed: "egg_kick_white4"),
                                          SKTexture(imageNamed: "egg_kick_white5")]
    var basicEggCrackedKickingTextures = [SKTexture(imageNamed: "egg_cracked_kick0"),
                                          SKTexture(imageNamed: "egg_cracked_kick1"),
                                          SKTexture(imageNamed: "egg_cracked_kick2"),
                                          SKTexture(imageNamed: "egg_cracked_kick3"),
                                          SKTexture(imageNamed: "egg_cracked_kick4"),
                                          SKTexture(imageNamed: "egg_cracked_kick5")]
    
    //var gameScene: GameScene!
    
    
    //var anim: SKAction
    
    
    override init(sprite: SKSpriteNode, scene: GameScene) {
        super.init(sprite: sprite, scene: scene)
        
        self.eggRunningTextures = basicEggRunningTextures
        self.eggDeathTextures = basicEggDeathTextures
        self.eggCrackedTextures = basicEggCrackedTextures
        self.eggKickingTextures = basicEggKickingTextures
        self.eggCrackedKickingTextures = basicEggCrackedKickingTextures
        
        self.runAnimateAction = SKAction.animate(with: self.eggRunningTextures, timePerFrame: 0.17)
        self.deathAnimateAction = SKAction.animate(with: self.eggDeathTextures, timePerFrame: 0.12)
        self.crackedAnimateAction = SKAction.animate(with: self.eggCrackedTextures, timePerFrame: 0.17)
        self.kickingAnimateAction = SKAction.animate(with: self.eggKickingTextures, timePerFrame: 0.17)
        self.crackedKickingAnimateAction = SKAction.animate(with: self.eggCrackedKickingTextures , timePerFrame: 0.25)
        self.animateAction = SKAction.repeatForever(runAnimateAction)
        
        self.coinRange = GameData.eggData.basicEgg.coinRange
        
    }
    
    override func addEgg() {
        self.sprite.name = "BasicEgg"
        //let actualY = random(min: 0 - gameScene.size.height / 2 + self.sprite.size.height, max: 275)
        let actualY = random(min: self.sprite.size.height + 20, max: 600)
        self.sprite.position = CGPoint(x: (0 - self.sprite.size.width), y: actualY)
        self.sprite.zPosition = 2
        self.sprite.scale(to: CGSize(width: 120, height: 120))
        self.runAnimate()
        
        
        
        //gameScene.eggLayer.addChild(self.sprite)
        gameScene.addChild(self.sprite)
        gameScene.eggArrayNodes.append(self.sprite)
        gameScene.eggArray.append(self)
        
    }
}
