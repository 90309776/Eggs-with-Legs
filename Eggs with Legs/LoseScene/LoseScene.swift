//
//  LoseScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/17/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class LoseScene: SKScene {
    
    var menuButtonSprite: SKSpriteNode!
    
    override func sceneDidLoad() {
        initNodes()
        //print("Day Count: \(GameData.DataStructure.day)")
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
        guard let mainMenuButtonSpriteNode = childNode(withName: "menuButtonSprite") as? SKSpriteNode else {
            fatalError("menuButtonSprite failed to load. Maybe not in childNode list?")
        }
        self.menuButtonSprite = mainMenuButtonSpriteNode
    }
    
    func pressedStartButton(touchLocation: CGPoint) {
        let startScene = StartScene(fileNamed: "StartScene")
        startScene?.scaleMode = .aspectFill
        
        if menuButtonSprite.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(startScene!, transition: reveal )
        }
    }
}
