//
//  SettingsScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/12/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

class SettingsScene: SKScene {
    
    var mainLayer: SKNode!
    var creditsLayer: SKNode!
    var backButton: Button!
    
    
    override func didMove(to view: SKView) {
        initNodes()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        pressedBackButton(touchLocation: touchLocation)
    }
    
    func pressedBackButton(touchLocation: CGPoint) {
        if backButton.hasTouched(touchLocation: touchLocation) {
            let startScene = StartScene(fileNamed: "StartScene")
            startScene?.scaleMode = .aspectFill
            view!.presentScene(startScene!)
        }
    }
    
    
    func initNodes() {
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("didnt load lol")
        }
        self.mainLayer = mainLayerNode
        
        guard let creditsLayerNode = mainLayer.childNode(withName: "creditsLayer") else {
            fatalError("didnt load lol")
        }
        self.creditsLayer = creditsLayerNode
        
        backButton = Button(children: mainLayer.children, name: "backButton")
        
        
    }
    
    func scaleScene() {
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
}
