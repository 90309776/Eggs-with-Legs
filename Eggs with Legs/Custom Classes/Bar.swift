//
//  Healthbar.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/6/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import Foundation
import SpriteKit

class Bar {
    
    /*
     Creates two SKSpriteNodes to mimic a border and a bar inside.
     Manipulate the bar to show a size difference.
     Prob should have used SKRect instead of sprites but oh well
    */
    
    
    var barBorder: SKSpriteNode
    var bar: SKSpriteNode
    var barMaxWidth: Int
    var gameScene: GameScene!
    
    init(eggSprite: SKSpriteNode, scene:  GameScene, size: CGSize) {
        self.gameScene = scene
        
        self.barBorder = SKSpriteNode()
        self.barMaxWidth = Int(size.width * 0.9)
        self.barBorder.size = CGSize(width: size.width, height: size.height)
        self.barBorder.position = CGPoint(x: eggSprite.position.x + 10, y: eggSprite.position.y + 115)
        self.barBorder.zPosition = 5
        self.barBorder.color = UIColor.white
        
        
        self.bar = SKSpriteNode()
        self.bar.size = CGSize(width: size.width * 0.9, height: size.height * 0.66)
        self.bar.anchorPoint = CGPoint(x: 0, y: 0)
        self.bar.position = CGPoint(x: eggSprite.position.x - self.bar.size.width / 2 + 10, y: (eggSprite.position.y + 115) - self.bar.size.height / 2)
        self.bar.zPosition = 6
        self.bar.color = UIColor.red

    }
    
    init(size: CGSize) {
        //self.gameScene = scene
        self.barBorder = SKSpriteNode()
        self.barBorder.size = CGSize(width: size.width, height: size.height)
        self.barBorder.zPosition = 5
        self.barBorder.color = UIColor.white
        
        self.barMaxWidth = Int(size.width * 0.9)
        
        self.bar = SKSpriteNode()
        self.barBorder.addChild(self.bar)
        self.bar.size = CGSize(width: size.width * 0.9, height: size.height * 0.66)
        self.bar.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.bar.position = CGPoint(x: (0 - size.width / 2) + (size.width * 0.10 / 2), y:  0)
        self.bar.zPosition = 6
        self.bar.color = UIColor.black
        
    }
    
}
