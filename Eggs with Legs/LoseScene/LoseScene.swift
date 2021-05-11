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
    

    //var menuButtonSprite: SKSpriteNode!
    var gameScene: GameScene!
    var sound: Sound!
    
    var mainLayer: SKNode!
    var menuButtonSprite: Button!
    

    
    override func sceneDidLoad() {
        sound = Sound()
        initNodes()
        gameScene = GameScene()
        
        if GameData.settingsData.music {
            sound.musicLoop(SoundName: "GameOverSong")
        }
        
        //sound.musicLoop(SoundName: "GameOverSong")
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
        
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("menuButtonSprite failed to load. Maybe not in childNode list?")
        }
        self.mainLayer = mainLayerNode
        
        menuButtonSprite = Button(children: mainLayer.children, name: "menuButton")
        
    }
    
    func pressedStartButton(touchLocation: CGPoint) {
        let startScene = StartScene(fileNamed: "StartScene")
        startScene?.scaleMode = .aspectFill
       
        if menuButtonSprite.hasTouched(touchLocation: touchLocation) {
            sound.stopMusic()
            resetGameData()
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(startScene!, transition: reveal)
        }
    }
    
    //Resets all local game data variables
    //Super ineffiecient will fix and change
    func resetGameData() {
        
        GameData.levelData.highscore = GameData.levelData.day
        
        var highscore = UserDefaults.standard.value(forKey: "highScore") as! Int
        
        if GameData.levelData.day - 1 >= highscore {
            UserDefaults.standard.set(GameData.levelData.day, forKey: "highScore")
        }
        
        
        
        GameData.levelData.day = 1
        
        GameData.levelData.eggSpawnInterval = 1
        GameData.levelData.maxEggs = 10
        GameData.levelData.timeMax = 30
        GameData.levelData.listOfEggs = ["BasicEgg"]
        
        GameData.playerData.coins = 0
        GameData.playerData.maxTapCount = 10
        GameData.playerData.playerDamage = 5
        GameData.playerData.tapBarDepletionRate = 0.003
        GameData.playerData.tapBarIncreaseRate = 0.13
        
        
        
        GameData.towerData.tower_1Activated = false
        GameData.towerData.tower_2Activated = false
        GameData.towerData.towerDamage = 5.0
        GameData.towerData.towerFireInterval = 3
        
        GameData.shopData.buyTowerCost = 1500
        GameData.shopData.upgradeTapBarCost = 200
        GameData.shopData.increaseTowerFireRateCost = 500
        GameData.shopData.increasePlayerDamageCost = 500
        GameData.shopData.upgradeFenceHealthCost = 250
        GameData.shopData.upgradeTowerDamageCost = 500
        
        GameData.fenceData.baseHealth = 20
        GameData.fenceData.fenceStage = 1
        GameData.fenceData.healthMultiplier = 1
        
        GameData.eggData.basicEgg.baseDamage = 1
        GameData.eggData.basicEgg.baseHealth = 10
        GameData.eggData.basicEgg.baseSpeed = 4
        GameData.eggData.basicEgg.coinRange = [20, 40]
        
        GameData.eggData.rollingEgg.baseDamage = 3
        GameData.eggData.rollingEgg.baseHealth = 5
        GameData.eggData.rollingEgg.baseSpeed = 6
        GameData.eggData.rollingEgg.coinRange = [40, 70]
        
        GameData.eggData.damageMultiplier = 1
        GameData.eggData.healthMultiplier = 1.0
        GameData.eggData.speedMultiplier = 1.0
        
        GameData.saveLocalData()
        
    }
    
}
