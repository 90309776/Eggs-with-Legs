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
    
    var nextButtonSprite: SKSpriteNode!
    var increaseTowerFireRateSprite: SKSpriteNode!
    
    override func sceneDidLoad() {
        initNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        pressedNextButton(touchLocation: touchLocation)
        pressedIncreaseFireRateButton(touchLocation: touchLocation)
        
        
    }
    
    
    /*
     REFERENCED FUNCTIONS ARE BELOW
     */
    
    func initNodes() {
        guard let nextButtonSpriteNode = childNode(withName: "nextLevelButton") as? SKSpriteNode else {
            fatalError("nextBUttonPSriteNode failed to load. Maybe not in childNode list?")
        }
        self.nextButtonSprite = nextButtonSpriteNode
        
        guard let increaseFireRateSpriteNode = childNode(withName: "increaseTowerFireRateButton") as? SKSpriteNode else {
            fatalError("fire rate button failed to load. Maybe not in childNode list?")
        }
        self.increaseTowerFireRateSprite = increaseFireRateSpriteNode
    }
    
    func pressedIncreaseFireRateButton(touchLocation: CGPoint) {
        if increaseTowerFireRateSprite.contains(touchLocation) {
            if GameData.towerData.towerFireInterval > 0.5 {
                GameData.towerData.towerFireInterval -= 0.20
                print("fire rate: \(GameData.towerData.towerFireInterval)")
            }
        }
    }
    
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
        
        //sleep(5)
        
        if nextButtonSprite.contains(touchLocation) {
            changeGameData(touchLocation: touchLocation)
            let reveal = SKTransition.fade(withDuration: 2)
            view!.presentScene(gameScene!, transition: reveal )
        }
    }
    
    func changeGameData(touchLocation: CGPoint) {
        GameData.levelData.day += 1
        GameData.fenceData.baseHealth += 20
        //GameData.towerData.towerFireInterval -= 0.20
        GameData.levelData.maxEggs += 5
        GameData.eggData.basicEgg.baseDamage += 2
        GameData.eggData.basicEgg.baseSpeed += 1
        
    }
}


