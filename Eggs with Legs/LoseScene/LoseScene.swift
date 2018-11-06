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
            resetGameData()
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(startScene!, transition: reveal )
            
        }
    }
    
    
    func resetGameData() {
        
        GameData.levelData.day = 1
        GameData.levelData.eggSpawnInterval = 1
        GameData.levelData.maxEggs = 10
        
        GameData.playerData.coins = 0
        GameData.playerData.maxTapCount = 10
        GameData.playerData.playerDamage = 5
        
        GameData.towerData.tower_1Activated = false
        GameData.towerData.tower_2Activated = false
        GameData.towerData.towerDamage = 5.0
        GameData.towerData.towerFireInterval = 3
        
        GameData.shopData.buyTowerCost = 1500
        GameData.shopData.upgradeWeaponCost = 200
        GameData.shopData.increaseTowerFireRateCost = 500
        GameData.shopData.increasePlayerDamageCost = 500
        GameData.shopData.upgradeFenceHealthCost = 250
        
        GameData.fenceData.baseHealth = 20
        GameData.fenceData.fenceStage = 1
        GameData.fenceData.healthMultiplier = 1
        
        GameData.eggData.basicEgg.baseDamage = 1
        GameData.eggData.basicEgg.baseHealth = 10
        GameData.eggData.basicEgg.baseSpeed = 10
        GameData.eggData.basicEgg.coinRange = [90, 150]
        
        GameData.eggData.rollingEgg.baseDamage = 3
        GameData.eggData.rollingEgg.baseHealth = 5
        GameData.eggData.rollingEgg.baseSpeed = 12
        
        GameData.eggData.damageMultiplier = 1
        GameData.eggData.healthMultiplier = 1.0
        GameData.eggData.speedMultiplier = 1.0
        
        
        
    }
    
}
