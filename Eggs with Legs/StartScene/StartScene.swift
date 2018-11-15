//
//  StartScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/16/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import GameplayKit
import Foundation

class StartScene: SKScene {
    
    var startButtonSprite: SKSpriteNode!
    var mainLayer: SKNode!
    
    
    override func sceneDidLoad() {
        initNodes()
        scaleScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        //If pressed, goes to tutorialScene
        pressedStartButton(touchLocation: touchLocation)
        //music doesn't stop till after tutorial
    }

    /*
     REFERENCED FUNCTIONS ARE BELOW
    */
    
    func initNodes() {
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.mainLayer = mainLayerNode
        
        guard let startButtonSpriteNode = mainLayer.childNode(withName: "buttonSprite") as? SKSpriteNode else {
            fatalError("startButtonSpriteNode failed to load. Maybe not in childNode list?")
        }
        self.startButtonSprite = startButtonSpriteNode
    }
    
    func pressedStartButton(touchLocation: CGPoint) {
        let tutorialScene = TutorialScene(fileNamed: "TutorialScene")
        tutorialScene?.scaleMode = .aspectFill
        
        if startButtonSprite.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(tutorialScene!, transition: reveal )
        }
    }
    //Sets the scene's mainlayer to scale to the device's playable area
    func scaleScene() {
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
}
