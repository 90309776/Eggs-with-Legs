//
//  WinScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/17/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class WinScene: SKScene {
    
    var startButtonSprite: SKSpriteNode!
    
    override func sceneDidLoad() {
        initNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        pressedStartButton(touchLocation: touchLocation)
        
        
    }
    
    
    /*
     REFERENCED FUNCTIONS ARE BELOW
     */
    
    func initNodes() {
//        guard let startButtonSpriteNode = childNode(withName: "buttonSprite") as? SKSpriteNode else {
//            fatalError("startButtonSpriteNode failed to load. Maybe not in childNode list?")
//        }
//        self.startButtonSprite = startButtonSpriteNode
    }
    
    func pressedStartButton(touchLocation: CGPoint) {
//        let gameScene = GameScene(fileNamed: "GameScene")
//        gameScene?.scaleMode = .aspectFill
//        
//        if startButtonSprite.contains(touchLocation) {
//            let reveal = SKTransition.fade(withDuration: 3)
//            view!.presentScene(gameScene!, transition: reveal )
//        }
    }
}


