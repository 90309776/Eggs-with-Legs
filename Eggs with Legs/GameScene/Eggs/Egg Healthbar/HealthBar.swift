//
//  Healthbar.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/6/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar {
    
    var healthBarBoarder: SKSpriteNode
    var healthBar: SKSpriteNode
    var healthBarMaxWidth = 90
    var gameScene: GameScene
    
    init(eggSprite: SKSpriteNode, scene:  GameScene) {
        self.gameScene = scene
        
        self.healthBarBoarder = SKSpriteNode()
        self.healthBarBoarder.size = CGSize(width: 100, height: 30)
        self.healthBarBoarder.position = CGPoint(x: eggSprite.position.x + 10, y: eggSprite.position.y + 115)
        self.healthBarBoarder.zPosition = 5
        self.healthBarBoarder.color = UIColor.white
        
        
        self.healthBar = SKSpriteNode()
        self.healthBar.size = CGSize(width: 90, height: 20)
        self.healthBar.anchorPoint = CGPoint(x: 0, y: 0)
        self.healthBar.position = CGPoint(x: eggSprite.position.x - self.healthBar.size.width / 2 + 10, y: (eggSprite.position.y + 115) - self.healthBar.size.height / 2)
        self.healthBar.zPosition = 6
        self.healthBar.color = UIColor.red
        
        //eggSprite.addChild(self.healthBarBoarder)
        
    }
    
}
