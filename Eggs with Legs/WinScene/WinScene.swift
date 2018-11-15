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
import AVFoundation

class WinScene: SKScene {
    
    var GameSceneMusical: GameScene!
    
    var playStuff: AVAudioPlayer?
    
    var shopLayer: SKNode!
    var statsLayer: SKNode!
    var mainLayer: SKNode!
    var secondaryLayer: SKNode!
    
    var mainShopSprite: SKSpriteNode!
    var nextLevelButton: SKSpriteNode!

    
    var coinSprite: SKSpriteNode!
    var coinAmountLabel: SKLabelNode!
    
    var dayStatLabel: SKLabelNode!
    var eggsCrackedStatLabel: SKLabelNode!
    var playerDamageStatLabel: SKLabelNode!
    var towerDamageStatLabel: SKLabelNode!
    var towerFireRateStatLabel: SKLabelNode!
    var fenceHealthStatLabel: SKLabelNode!
    var totalDamageTakenStatLabel: SKLabelNode!
    
    
    var increasePlayerDamageButton: ShopButton!
    var increaseTowerFireRateButton: ShopButton!
    var upgradeFenceButton: ShopButton!
    var upgradeWeaponButton: ShopButton!
    var buyTowerButton: ShopButton!
    
    var shopTabButton: ShopButton!
    var statsTabButton: ShopButton!
    
    override func didMove(to view: SKView) {
        initNodes()
        initObjects()
        scaleScene()
        //saveLocalData()
        GameData.saveLocalData()
        GameSceneMusical = GameScene()
        GameSceneMusical.musicLoop(SoundName: "Roads")
    }
    
    override func sceneDidLoad() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        /*
         Checks the touchlocation of the user to see if they pressed
         a specific button. If so, it will execute that button's stuff
        */
        pressedNextButton(touchLocation: touchLocation)
        pressedIncreasePlayerDamageButton(touchLocation: touchLocation)
        pressedIncreaseFireRateButton(touchLocation: touchLocation)
        pressedUpgradeFenceButton(touchLocation: touchLocation)
        pressedUpgradeWeaponButton(touchLocation: touchLocation)
        pressedBuyTowerButton(touchLocation: touchLocation)
        
        pressedShopButton(touchLocation: touchLocation)
        pressedStatsButton(touchLocation: touchLocation)
        //saveLocalData()

    }
    
    //Makes the game scale in difficulty every time a day is passed
    func changeGameData(touchLocation: CGPoint) {
        GameData.levelData.day += 1
        GameData.levelData.maxEggs += 5
        GameData.fenceData.baseHealth += 10
        
        //When day is less than 10
        if GameData.levelData.day <= 10 {
            //For ever 2 days that is less than 10 days
            if GameData.levelData.day % 2 == 0 {
                GameData.eggData.basicEgg.baseHealth += 1
                GameData.eggData.rollingEgg.baseHealth += 2
            }
            
            
        }
        
        if GameData.levelData.day % 2 == 0 && GameData.levelData.day <= 16 {
            GameData.eggData.basicEgg.baseDamage += 1
            GameData.eggData.basicEgg.baseSpeed += 0.5
            
            GameData.eggData.rollingEgg.baseDamage += 2
            GameData.eggData.rollingEgg.baseSpeed += 0.33
        }
        
        if GameData.levelData.day % 5 == 0 && GameData.levelData.day < 30 {
            GameData.eggData.speedMultiplier += 0.10
            
        }
        
        //Every 10 days
        if GameData.levelData.day % 10 == 0 {
            GameData.levelData.maxEggs += 10
            GameData.eggData.healthMultiplier += 0.15
            GameData.eggData.speedMultiplier += 0.10
        }
        
    }
    
    func saveLocalData() {
        //LEVELDATA
        UserDefaults.standard.set(GameData.levelData.day, forKey: "levelDataDay")
        UserDefaults.standard.set(GameData.levelData.maxEggs, forKey: "levelDataMaxEggs")
        UserDefaults.standard.set(GameData.levelData.eggSpawnInterval, forKey: "levelDataSpawnInterval")
        
        //PLAYERDATA
        UserDefaults.standard.set(GameData.playerData.coins, forKey: "playerDataCoins")
        UserDefaults.standard.set(GameData.playerData.playerDamage, forKey: "playerDataDamage")
        UserDefaults.standard.set(GameData.playerData.maxTapCount, forKey: "playerDataMaxTapCount")
        UserDefaults.standard.set(GameData.playerData.cooldownInterval, forKey: "playerDataCoolDownInterval")
        
        //TOWERDATA
        UserDefaults.standard.set(GameData.towerData.tower_1Activated, forKey: "towerDataTower1")
        UserDefaults.standard.set(GameData.towerData.tower_2Activated, forKey: "towerDataTower2")
        UserDefaults.standard.set(GameData.towerData.towerFireInterval, forKey: "towerDataFireInterval")
        UserDefaults.standard.set(GameData.towerData.towerDamage, forKey: "towerDataDamage")
        
        //SHOPDATA
        UserDefaults.standard.set(GameData.shopData.buyTowerCost, forKey: "shopDataBuyTowerCost")
        UserDefaults.standard.set(GameData.shopData.upgradeWeaponCost, forKey: "shopDataUpgradeWeaponCost")
        UserDefaults.standard.set(GameData.shopData.increaseTowerFireRateCost, forKey: "shopDataIncreaseFireRateCost")
        UserDefaults.standard.set(GameData.shopData.upgradeFenceHealthCost, forKey: "shopDataUpgradeFenceHealthCost")
        UserDefaults.standard.set(GameData.shopData.increasePlayerDamageCost, forKey: "shopDataIncreasePlayerDamageCost")
        
        //EGGDATA - BASICEGG
        UserDefaults.standard.set(GameData.eggData.basicEgg.baseSpeed, forKey: "basicEggSpeed")
        UserDefaults.standard.set(GameData.eggData.basicEgg.baseHealth, forKey: "basicEggHealth")
        UserDefaults.standard.set(GameData.eggData.basicEgg.baseDamage, forKey: "basicEggDamage")
        UserDefaults.standard.set(GameData.eggData.basicEgg.coinRange, forKey: "basicEggCoinRange")
        //EGGDATA - ROLLINGEGG
        UserDefaults.standard.set(GameData.eggData.rollingEgg.baseSpeed, forKey: "rollingEggSpeed")
        UserDefaults.standard.set(GameData.eggData.rollingEgg.baseHealth, forKey: "rollingEggHealth")
        UserDefaults.standard.set(GameData.eggData.rollingEgg.baseDamage, forKey: "rollingEggDamage")
        UserDefaults.standard.set(GameData.eggData.rollingEgg.coinRange, forKey: "rollingEggCoinRange")
        //EGGDATA
        UserDefaults.standard.set(GameData.eggData.speedMultiplier, forKey: "eggDataSpeedMulti")
        UserDefaults.standard.set(GameData.eggData.healthMultiplier, forKey: "eggDataHealthMulti")
        UserDefaults.standard.set(GameData.eggData.damageMultiplier, forKey: "eggDataDamageMulti")
        
        //FENCEDATA
        UserDefaults.standard.set(GameData.fenceData.baseHealth, forKey: "fenceDataHealth")
        UserDefaults.standard.set(GameData.fenceData.healthMultiplier, forKey: "fenceDataHealthMulti")
        UserDefaults.standard.set(GameData.fenceData.fenceStage, forKey: "fenceDataStage")
        
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        updateLabels()
    }
    
    /*
     REFERENCED FUNCTIONS ARE BELOW
     */
    
    func pressedIncreaseFireRateButton(touchLocation: CGPoint) {
        if increaseTowerFireRateButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.increaseTowerFireRateCost {
            if GameData.towerData.towerFireInterval > 0.5 {
                GameData.playerData.coins -= GameData.shopData.increaseTowerFireRateCost
                GameData.towerData.towerFireInterval -= 0.20
                increaseTowerFireRateButton.secondaryLabel.text = "Rate: \(String(format: "%.2f", 1 / GameData.towerData.towerFireInterval))/s"
                
                GameData.shopData.increaseTowerFireRateCost += Int(Double(GameData.shopData.increaseTowerFireRateCost) * 0.10)
            }
        }
    }
    
    func pressedIncreasePlayerDamageButton(touchLocation: CGPoint) {
        if increasePlayerDamageButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.increasePlayerDamageCost {
            GameData.playerData.coins -= GameData.shopData.increasePlayerDamageCost
            GameData.playerData.playerDamage += 2
            increasePlayerDamageButton.secondaryLabel.text = "Dmg: \(String(Int(GameData.playerData.playerDamage)))"
            
            GameData.shopData.increasePlayerDamageCost += Int(Double(GameData.shopData.increasePlayerDamageCost) * 0.30)
        }
    }
    
    func pressedUpgradeWeaponButton(touchLocation: CGPoint) {
        if upgradeWeaponButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeWeaponCost {
            GameData.playerData.coins -= GameData.shopData.upgradeWeaponCost
            GameData.playerData.maxTapCount += 4
            if GameData.playerData.cooldownInterval >= 0.5 {
                GameData.playerData.cooldownInterval -= 0.25
            }
            
            GameData.shopData.upgradeWeaponCost += Int(Double(GameData.shopData.upgradeWeaponCost) * 0.15)
        }
    }
    
    func pressedUpgradeFenceButton(touchLocation: CGPoint) {
        if upgradeFenceButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeFenceHealthCost {
            GameData.playerData.coins -= GameData.shopData.upgradeFenceHealthCost
            GameData.fenceData.baseHealth += 20
            
            GameData.shopData.upgradeFenceHealthCost += Int(Double(GameData.shopData.upgradeFenceHealthCost) * 0.20)
        }
    }
    
    func pressedBuyTowerButton(touchLocation: CGPoint) {
        if buyTowerButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.buyTowerCost && buyTowerButton.isButtonEnabled{
            if GameData.towerData.tower_1Activated == false {
                GameData.playerData.coins -= GameData.shopData.buyTowerCost
                GameData.towerData.tower_1Activated = true
                
                GameData.shopData.buyTowerCost += 3000
                //buy
                buyTowerButton.descLabel.text = "+1 Tower (1/2)"
            } else if GameData.towerData.tower_2Activated == false {
                GameData.playerData.coins -= GameData.shopData.buyTowerCost
                GameData.towerData.tower_2Activated = true
                GameData.shopData.buyTowerCost = 0
                buyTowerButton.descLabel.text = "SOLD OUT"
                
                //buyTowerButton.spriteButton.isHidden = true
            }
        }
    }
    
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        if  nextLevelButton.contains(touchLocation){
            changeGameData(touchLocation: touchLocation)
            let reveal = SKTransition.fade(withDuration: 2)
            view!.presentScene(gameScene!, transition: reveal )
        }
    }
    
    func pressedShopButton(touchLocation: CGPoint) {
        if shopTabButton.spriteButton.contains(touchLocation) {
            statsLayer.isHidden = true
            shopLayer.isHidden = false
            shopTabButton.descLabel.alpha = 1
            statsTabButton.descLabel.alpha = 0.2
        }
    }
    
    func pressedStatsButton(touchLocation: CGPoint) {
        if statsTabButton.spriteButton.contains(touchLocation) {
            statsLayer.isHidden = false
            shopLayer.isHidden = true
            shopTabButton.descLabel.alpha = 0.2
            statsTabButton.descLabel.alpha = 1
        }
    }
    
    //Updates costs labels of every shop item
    //This can prob be more efficient
    func updateLabels() {
        coinAmountLabel.text = String(GameData.playerData.coins)
        
        increaseTowerFireRateButton.costLabel.text = String(GameData.shopData.increaseTowerFireRateCost)
        increasePlayerDamageButton.costLabel.text = String(GameData.shopData.increasePlayerDamageCost)
        upgradeFenceButton.costLabel.text = String(GameData.shopData.upgradeFenceHealthCost)
        upgradeWeaponButton.costLabel.text = String(GameData.shopData.upgradeWeaponCost)
        if GameData.towerData.tower_2Activated {
            buyTowerButton.descLabel.text = "SOLD OUT"
        } else if GameData.towerData.tower_1Activated {
            buyTowerButton.descLabel.text = "+ Tower (1/2)"
            buyTowerButton.costLabel.text = String(GameData.shopData.buyTowerCost)
        } else {
            buyTowerButton.costLabel.text = String(GameData.shopData.buyTowerCost)
        }
        
        if !statsLayer.isHidden {
            dayStatLabel.text = "Day \(GameData.levelData.day)"
            eggsCrackedStatLabel.text = "Total Eggs Cracked: \(GameData.stats.totalEggsCracked)"
            playerDamageStatLabel.text = "Current Damage: \(GameData.playerData.playerDamage)"
            towerDamageStatLabel.text = "Tower Damage: \(GameData.towerData.towerDamage)"
            towerFireRateStatLabel.text = "Tower Fire Rate: \(String(format: "%.2f", 1 / GameData.towerData.towerFireInterval))/s"
            fenceHealthStatLabel.text = "Fence Health: \(GameData.fenceData.baseHealth)"
            totalDamageTakenStatLabel.text = "Total Damage Taken: \(GameData.stats.totalDamageTaken)"
        }
        
        
    }
    
    func scaleScene() {
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
    func initNodes() {
        
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError()
        }
        self.mainLayer = mainLayerNode
        
        guard let shopLayerNode = mainLayer.childNode(withName: "shopLayer") else {
            fatalError()
        }
        self.shopLayer = shopLayerNode
        
        guard let statsLayerNode = mainLayer.childNode(withName: "statsLayer") else {
            fatalError()
        }
        self.statsLayer = statsLayerNode
        
        guard let secondaryLayerNode = mainLayer.childNode(withName: "secondaryLayer") else {
            fatalError()
        }
        self.secondaryLayer = secondaryLayerNode
        
        guard let nextLevelNode = shopLayer.childNode(withName: "nextLevelSprite") as? SKSpriteNode else {
            fatalError("nextBUttonPSriteNode failed to load. Maybe not in childNode list?")
        }
        self.nextLevelButton = nextLevelNode
        
        guard let mainShopNode = shopLayer.childNode(withName: "mainShopSprite") as? SKSpriteNode else {
            fatalError("mainShopNode failed to load. Maybe not in childNode list?")
        }
        self.mainShopSprite = mainShopNode
        
        guard let coinLabelNode = mainShopSprite.childNode(withName: "coinAmountLabel") as? SKLabelNode else {
            fatalError("coinlabelnode failed to load. Maybe not in childNode list?")
        }
        
        self.coinAmountLabel = coinLabelNode
        self.coinAmountLabel.text = String(Int(GameData.playerData.coins))
        
        guard let dayStatNode = statsLayer.childNode(withName: "dayStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.dayStatLabel = dayStatNode
        
//        var dayStatLabel: SKLabelNode!
//        var eggsCrackedStatLabel: SKLabelNode!
//        var playerDamageStatLabel: SKLabelNode!
//        var towerDamageStatLabel: SKLabelNode!
//        var towerFireRateStatLabel: SKLabelNode!
//        var fenceHealthStatLabel: SKLabelNode!
//        var totalDamageTakenStatLabel: SKLabelNode!
        
        guard let eggsCrackedNode = statsLayer.childNode(withName: "eggsCrackedStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.eggsCrackedStatLabel = eggsCrackedNode
        
        guard let playerDamageNode = statsLayer.childNode(withName: "playerDamageStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.playerDamageStatLabel = playerDamageNode
        
        guard let towerDamageNode = statsLayer.childNode(withName: "towerDamageStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.towerDamageStatLabel = towerDamageNode
        
        guard let towerFireStat = statsLayer.childNode(withName: "towerFireRateStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.towerFireRateStatLabel = towerFireStat
        
        guard let fenceHealthNode = statsLayer.childNode(withName: "fenceHealthStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.fenceHealthStatLabel = fenceHealthNode
        
        guard let totalDamageNode = statsLayer.childNode(withName: "totalDamageTakenStat") as? SKLabelNode else {
            fatalError("dayStat failed to load. Maybe not in childNode list?")
        }
        self.totalDamageTakenStatLabel = totalDamageNode
        
        statsLayer.alpha = 1
        statsLayer.isHidden = true
        
    }
    
    //Initializes the custom button object for every "Button" in the scene
    func initObjects() {
        increasePlayerDamageButton = ShopButton(children: shopLayer.children, name: "increasePlayerDamageSprite")
        increaseTowerFireRateButton = ShopButton(children: shopLayer.children, name: "increaseTowerFireRateButton")
        upgradeWeaponButton = ShopButton(children: shopLayer.children, name: "upgradeWeaponButton")
        upgradeFenceButton = ShopButton(children: shopLayer.children, name: "upgradeFenceButton")
        buyTowerButton = ShopButton(children: shopLayer.children, name: "buyTowerButton")
        
        shopTabButton = ShopButton(children: secondaryLayer.children, name: "shopTabButton")
        statsTabButton = ShopButton(children: secondaryLayer.children, name: "statsTabButton")
        
        
    }
    
}

