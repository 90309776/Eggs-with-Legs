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
    
    var nextButton: Button!
    var nextCameraPosButton: Button!
    var mainLayer: SKNode!

    var gameScene: GameScene!
    var sound: Sound!

    var mainCamera: SKCameraNode!

    
    override func didMove(to view: SKView) {
        initNodes()
        scaleScene()
        gameScene = GameScene()
        sound = Sound()
        
        sound.musicLoop(SoundName: "MenuLoop")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        //If pressed, goes to gameScene
        pressedNextButton(touchLocation: touchLocation)
        //pressedNextPositionButton(touchLocation: touchLocation)
    }
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = TutorialLevel1(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
            

        if nextButton.hasTouched(touchLocation: touchLocation) {

            let reveal = SKTransition.fade(withDuration: 1.5)
            view!.presentScene(gameScene!, transition: reveal)
        }
    }
    
    func pressedNextPositionButton(touchLocation: CGPoint) {
        if nextCameraPosButton.hasTouched(touchLocation: touchLocation) {
            mainCamera.position.x += 300
            print("\(mainCamera.position.x)")
            print("moved")
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
        
        guard let cameraNode = childNode(withName: "camera") as? SKCameraNode else {
            fatalError("didnt load lol")
        }
        self.mainCamera = cameraNode
        self.camera = mainCamera
        
        nextButton = Button(children: mainLayer.children, name: "nextButton")
        nextCameraPosButton = Button(children: mainLayer.children, name: "nextPosition")
    }
}
