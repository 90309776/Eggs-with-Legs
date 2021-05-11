//
//  LoadingScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/10/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class LoadingScene: SKScene {
    
    override func didMove(to view: SKView) {
        setSceneScaling()
        //GameData.saveLocalData()
        registerUserDefaults()
        loadLocalData()
        showStartScene()
        
    }
    
    func showStartScene() {
        let startScene = StartScene(fileNamed: "StartScene")
        startScene?.scaleMode = .aspectFill
        view!.presentScene(startScene!)
        print("Sucessfully loaded pre-game contents")
    }
    
    /*
     Calibrates the scaling ratio need to stretched or shrink
     the current scene's height.
     Also creates a rectangle that can be used as a preferenced for
     what will be used in the frame for every deveice and placements
     of elements
    */
    func setSceneScaling () {
        //Get aspect ratio of the current device
        let deviceWidth = UIScreen.main.bounds.width
        let deviceHeight = UIScreen.main.bounds.height
        
        print("w: \(deviceWidth), h: \(deviceHeight)")
        
        let maxAspectRatio: CGFloat = deviceWidth / deviceHeight
        
        //This is the heightRatio between deviceHeight and deviceWidth
        //to be used to scale the "scene" properly
        let heightRatio: CGFloat = deviceHeight / deviceWidth
        
        //Setup playable area for landscape origentaion
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        //Scales "scene" to fit the device. Causes some height distortion but it works
        GameData.sceneScaling.sceneYScale = heightRatio + (heightRatio / 3)
        GameData.sceneScaling.playableArea = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        GameData.sceneScaling.playableAreaOrigin = CGPoint(x: GameData.sceneScaling.playableArea.minX, y: GameData.sceneScaling.playableArea.minY)
        
    }
    
    func registerUserDefaults() {
        //UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
        //UserDefaults.standard.register(defaults: ["levelDataMaxEggs" : 1])
        //UserDefaults.standard.register(defaults: ["levelDataSpawnInterval" : 1])
        UserDefaults.standard.register(defaults: ["highScore" : 0])
        UserDefaults.standard.register(defaults: ["eggscracked" : 0])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//        UserDefaults.standard.register(defaults: ["levelDataDay" : 1])
//
        //User
    }
    
    
    func loadLocalData() {
//        GameData.levelData.day = UserDefaults.standard.value(forKey: "levelDataDay") as! Int
//        GameData.levelData.eggSpawnInterval = UserDefaults.standard.value(forKey: "levelDataSpawnInterval") as! TimeInterval
//        GameData.levelData.maxEggs = UserDefaults.standard.value(forKey: "levelDataMaxEggs") as! Int
//
        GameData.levelData.highscore = UserDefaults.standard.value(forKey: "highScore") as! Int
//
//        GameData.playerData.coins = UserDefaults.standard.value(forKey: "playerDataCoins") as! Int
//        GameData.playerData.maxTapCount = UserDefaults.standard.value(forKey: "playerDataMaxTapCount") as! Int
//        GameData.playerData.playerDamage = UserDefaults.standard.value(forKey: "playerDataDamage") as! Double
//
//        GameData.towerData.tower_1Activated = (UserDefaults.standard.value(forKey: "towerDataTower1") != nil)
//        GameData.towerData.tower_2Activated = (UserDefaults.standard.value(forKey: "towerDataTower2") != nil)
//        GameData.towerData.towerDamage = UserDefaults.standard.value(forKey: "towerDataDamage") as! Double
//        GameData.towerData.towerFireInterval = UserDefaults.standard.value(forKey: "towerDataFireInterval") as! TimeInterval
//
//        GameData.shopData.buyTowerCost = UserDefaults.standard.value(forKey: "shopDataBuyTowerCost") as! Int
//        GameData.shopData.upgradeTapBarCost = UserDefaults.standard.value(forKey: "shopDataupgradeTapBarCost") as! Int
//        GameData.shopData.increaseTowerFireRateCost = UserDefaults.standard.value(forKey: "shopDataIncreaseFireRateCost") as! Int
//        GameData.shopData.increasePlayerDamageCost = UserDefaults.standard.value(forKey: "shopDataIncreasePlayerDamageCost") as! Int
//        GameData.shopData.upgradeFenceHealthCost = UserDefaults.standard.value(forKey: "shopDataUpgradeFenceHealthCost") as! Int
//
//        GameData.fenceData.baseHealth = UserDefaults.standard.value(forKey: "fenceDataHealth") as! Int
//        GameData.fenceData.fenceStage = UserDefaults.standard.value(forKey: "fenceDataStage") as! Int
//        GameData.fenceData.healthMultiplier = UserDefaults.standard.value(forKey: "fenceDataHealthMulti") as! Int
//
//        GameData.eggData.basicEgg.baseDamage = UserDefaults.standard.value(forKey: "basicEggDamage") as! Int
//        GameData.eggData.basicEgg.baseHealth = UserDefaults.standard.value(forKey: "basicEggHealth") as! Double
//        GameData.eggData.basicEgg.baseSpeed = UserDefaults.standard.value(forKey: "basicEggSpeed") as! Double
//        GameData.eggData.basicEgg.coinRange = UserDefaults.standard.value(forKey: "basicEggCoinRange") as! [Int]
//
//        GameData.eggData.rollingEgg.baseDamage = UserDefaults.standard.value(forKey: "rollingEggDamage") as! Int
//        GameData.eggData.rollingEgg.baseHealth = UserDefaults.standard.value(forKey: "rollingEggHealth") as! Double
//        GameData.eggData.rollingEgg.baseSpeed = UserDefaults.standard.value(forKey: "rollingEggSpeed") as! Double
//        GameData.eggData.rollingEgg.coinRange = UserDefaults.standard.value(forKey: "rollingEggCoinRange") as! [Int]
//
//        GameData.eggData.damageMultiplier = UserDefaults.standard.value(forKey: "eggDataDamageMulti") as! Int
//        GameData.eggData.healthMultiplier = UserDefaults.standard.value(forKey: "eggDataHealthMulti") as! Double
//        GameData.eggData.speedMultiplier = UserDefaults.standard.value(forKey: "eggDataSpeedMulti") as! Double
    }
    
}
