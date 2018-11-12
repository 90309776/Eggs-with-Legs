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
    var mainLayer: SKNode!
    
    override func didMove(to view: SKView) {
        initNodes()
        scaleScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        //If pressed, goes to gameScene
        pressedNextButton(touchLocation: touchLocation)
    }
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        if nextButton.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 1.5)
            view!.presentScene(gameScene!, transition: reveal )
        }
    }
    
    //Needed function to scale the height of the scene to device
    func scaleScene() {
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
    func initNodes() {
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("didnt load lol")
        }
        self.mainLayer = mainLayerNode
        
        guard let nextButtonNode = mainLayer.childNode(withName: "nextButton") as? SKSpriteNode else {
            fatalError("didnt load lol")
        }
        self.nextButton = nextButtonNode
    }
}
