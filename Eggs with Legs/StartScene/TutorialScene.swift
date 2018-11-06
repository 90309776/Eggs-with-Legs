//
//  TutorialScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/5/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class TutorialScene: SKScene {
    
    var nextButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        print("asdasdasd")
        initNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        pressedNextButton(touchLocation: touchLocation)
    }
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
        if nextButton.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(gameScene!, transition: reveal )
        }
    }
    
    
    func initNodes() {
        guard let nextButtonNode = childNode(withName: "nextButton") as? SKSpriteNode else {
            fatalError("didnt load lol")
        }
        self.nextButton = nextButtonNode
    }
}
