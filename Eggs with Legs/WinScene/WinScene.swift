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
    
    var sound: Sound!
    
    var soundPlayer: AVAudioPlayer?
    
    var shopLayer: SKNode!
    var statsLayer: SKNode!
    var mainLayer: SKNode!
    var secondaryLayer: SKNode!
    
    var mainShopSprite: SKSpriteNode!
    var nextLevelButton: SKSpriteNode!

    
    var coinSprite: SKSpriteNode!
    var coinAmountLabel: SKLabelNode!
    
    var dayStatLabelSet: LabelSet!
    var eggsCrackedStatLabelSet: LabelSet!
    var playerDamageStatLabelSet: LabelSet!
    var towerDamageStatLabelSet: LabelSet!
    var towerFireRateStatLabelSet: LabelSet!
    var fenceHealthStatLabelSet: LabelSet!
    var totalDamageTakenStatLabelSet: LabelSet!
    
    
    var increasePlayerDamageButton: Button!
    var increaseTowerFireRateButton: Button!
    var upgradeFenceButton: Button!
    var upgradeTapBarButton: Button!
    var buyTowerButton: Button!
    var upgradeTowerDamageButton: Button!
    
    var shopTabButton: Button!
    var statsTabButton: Button!
    
    override func didMove(to view: SKView) {
        initNodes()
        initObjects()
        scaleScene()
        //saveLocalData()
        GameData.saveLocalData()
        sound = Sound()
        if GameData.settingsData.music {
            sound.musicLoop(SoundName: "ShopSong")
        }
        
        //sound.musicLoop(SoundName: "ShopSong")
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
        pressedupgradeTapBarButton(touchLocation: touchLocation)
        pressedBuyTowerButton(touchLocation: touchLocation)
        pressedUpgradeTowerDamageButton(touchLocation: touchLocation)
        
        pressedShopButton(touchLocation: touchLocation)
        pressedStatsButton(touchLocation: touchLocation)
        //saveLocalData()

    }
    
    //Makes the game scale in difficulty every time a day is passed
    
    
    //not used yet playying around with saving local data
    //im pretty sure this is not how its supposed to be
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
        UserDefaults.standard.set(GameData.shopData.upgradeTapBarCost, forKey: "shopDataupgradeTapBarCost")
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
                
                GameData.shopData.increaseTowerFireRateCost += Int(Double(GameData.shopData.increaseTowerFireRateCost) * 0.20) + 100
            }
        }
    }
    
    func pressedIncreasePlayerDamageButton(touchLocation: CGPoint) {
        if increasePlayerDamageButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.increasePlayerDamageCost {
            GameData.playerData.coins -= GameData.shopData.increasePlayerDamageCost
            GameData.playerData.playerDamage += 2
            increasePlayerDamageButton.secondaryLabel.text = "Dmg: \(String(Int(GameData.playerData.playerDamage)))"
            
            GameData.shopData.increasePlayerDamageCost += Int(Double(GameData.shopData.increasePlayerDamageCost) * 0.30) + 100
        }
    }
    
    func pressedupgradeTapBarButton(touchLocation: CGPoint) {
        if upgradeTapBarButton.hasTouched(touchLocation: touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeTapBarCost {
            GameData.playerData.coins -= GameData.shopData.upgradeTapBarCost
            if GameData.playerData.tapBarDepletionRate <= 0.01 {
                GameData.playerData.cooldownInterval += 0.000125
            }
            
            GameData.shopData.upgradeTapBarCost += Int(Double(GameData.shopData.upgradeTapBarCost) * 0.425) + 100
        }
    }
    
    func pressedUpgradeFenceButton(touchLocation: CGPoint) {
        if upgradeFenceButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeFenceHealthCost {
            GameData.playerData.coins -= GameData.shopData.upgradeFenceHealthCost
            GameData.fenceData.baseHealth += 20
            
            GameData.shopData.upgradeFenceHealthCost += Int(Double(GameData.shopData.upgradeFenceHealthCost) * 0.33) + 100
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
    
    func pressedUpgradeTowerDamageButton(touchLocation: CGPoint) {
        if upgradeTowerDamageButton.hasTouched(touchLocation: touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeTowerDamageCost && upgradeTowerDamageButton.isButtonEnabled {
            GameData.towerData.towerDamage += 1
            GameData.playerData.coins -= GameData.shopData.upgradeTowerDamageCost
            GameData.shopData.upgradeTowerDamageCost += Int(Double(GameData.shopData.upgradeTowerDamageCost) * 0.33)
        }
    }
    
    
    func pressedNextButton(touchLocation: CGPoint) {
        
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        if  nextLevelButton.contains(touchLocation){
            sound.stopMusic()
            changeEggData()
            changeListEggs()
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
        upgradeTapBarButton.costLabel.text = String(GameData.shopData.upgradeTapBarCost)
        upgradeTowerDamageButton.costLabel.text = String(GameData.shopData.upgradeTowerDamageCost)
        if GameData.towerData.tower_2Activated {
            buyTowerButton.descLabel.text = "SOLD OUT"
        } else if GameData.towerData.tower_1Activated {
            buyTowerButton.descLabel.text = "+ Tower (1/2)"
            buyTowerButton.costLabel.text = String(GameData.shopData.buyTowerCost)
        } else {
            buyTowerButton.costLabel.text = String(GameData.shopData.buyTowerCost)
        }
        
        if !statsLayer.isHidden {
            dayStatLabelSet.mainLabel.text = "Day \(GameData.levelData.day)"
            eggsCrackedStatLabelSet.secondaryLabel.text = "\(GameData.stats.totalEggsCracked)"
            playerDamageStatLabelSet.secondaryLabel.text = "\(GameData.playerData.playerDamage)"
            towerDamageStatLabelSet.secondaryLabel.text = "\(GameData.towerData.towerDamage)"
            towerFireRateStatLabelSet.secondaryLabel.text = "\(String(format: "%.2f", 1 / GameData.towerData.towerFireInterval))/s"
            fenceHealthStatLabelSet.secondaryLabel.text = "\(GameData.fenceData.baseHealth)"
            totalDamageTakenStatLabelSet.secondaryLabel.text = "\(GameData.stats.totalDamageTaken)"
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

        shopLayer.alpha = 1
        statsLayer.alpha = 1
        statsLayer.isHidden = true
        
        var tempHighscore = UserDefaults.standard.value(forKey: "highScore") as! Int
        
        if GameData.levelData.day >= tempHighscore {
             UserDefaults.standard.set(GameData.levelData.day, forKey: "highScore")
        }
        
        //UserDefaults.standard.set(GameData.levelData.day, forKey: "highScore")
        
    }
    
    //Initializes the custom button object for every "Button" in the scene
    func initObjects() {
        increasePlayerDamageButton = Button(children: shopLayer.children, name: "increasePlayerDamageSprite")
        increaseTowerFireRateButton = Button(children: shopLayer.children, name: "increaseTowerFireRateButton")
        upgradeTapBarButton = Button(children: shopLayer.children, name: "upgradeTapBarButton")
        upgradeFenceButton = Button(children: shopLayer.children, name: "upgradeFenceButton")
        buyTowerButton = Button(children: shopLayer.children, name: "buyTowerButton")
        upgradeTowerDamageButton = Button(children: shopLayer.children, name: "upgradeTowerDamage")
        
        shopTabButton = Button(children: secondaryLayer.children, name: "shopTabButton")
        statsTabButton = Button(children: secondaryLayer.children, name: "statsTabButton")
        
        dayStatLabelSet = LabelSet(children: statsLayer.children, name: "dayStat")
        eggsCrackedStatLabelSet = LabelSet(children: statsLayer.children, name: "eggsCrackedStat")
        playerDamageStatLabelSet = LabelSet(children: statsLayer.children, name: "playerDamageStat")
        towerDamageStatLabelSet = LabelSet(children: statsLayer.children, name: "towerDamageStat")
        towerFireRateStatLabelSet = LabelSet(children: statsLayer.children, name: "towerFireRateStat")
        fenceHealthStatLabelSet = LabelSet(children: statsLayer.children, name: "fenceHealthStat")
        totalDamageTakenStatLabelSet = LabelSet(children: statsLayer.children, name: "totalDamageTakenStat")
        
    }
    
    func changeListEggs() {
        if GameData.levelData.day == 2 {
            GameData.levelData.listOfEggs = ["BasicEgg", "RollingEgg"]
            GameData.levelData.eggSpawnInterval = 1.25
        } else if GameData.levelData.day == 3 {
            GameData.levelData.listOfEggs = ["RollingEgg"]
            GameData.levelData.eggSpawnInterval = 1.25
        } else if GameData.levelData.day == 4 {
            GameData.levelData.listOfEggs = ["BasicEgg", "EggNog"]
            GameData.levelData.eggSpawnInterval = 1
            
        
        } else if GameData.levelData.day == 5 {
            GameData.levelData.listOfEggs = ["RussianEgg"]
            GameData.levelData.eggSpawnInterval = 1
            GameData.levelData.maxEggs = 1
        }
        else if GameData.levelData.day == 6 {
            GameData.levelData.listOfEggs = ["rainbowEgg"]
            GameData.levelData.maxEggs = 1000
            GameData.levelData.eggSpawnInterval = 0.75
            GameData.levelData.timeMax = 15
        } else if GameData.levelData.day == 10 {
            GameData.levelData.timeMax = 60
            GameData.levelData.listOfEggs = ["RussianEgg"]
            GameData.levelData.eggSpawnInterval = 5
            GameData.levelData.maxEggs = 2
        } else {
            GameData.levelData.timeMax = 30
            GameData.levelData.listOfEggs = ["BasicEgg", "RollingEgg", "EggNog"]
            GameData.levelData.eggSpawnInterval = 1.2
        }
        
        
  
        
    }
    
    func changeEggData() {
        GameData.levelData.day += 1
        //GameData.levelData.maxEggs += 5
        GameData.fenceData.baseHealth += 10
        
        //When day is less than 10
        if GameData.levelData.day <= 10 {
            //For ever 2 days that is less than 10 days
            if GameData.levelData.day % 2 == 0 {
                GameData.eggData.basicEgg.baseHealth += 1
                GameData.eggData.rollingEgg.baseHealth += 2
            }
        }
        
        if GameData.levelData.day % 2 == 0 && GameData.levelData.day <= 12 {
            GameData.eggData.basicEgg.baseDamage += 1
            GameData.eggData.basicEgg.baseSpeed += 0.15
            
            GameData.eggData.rollingEgg.baseDamage += 2
            GameData.eggData.rollingEgg.baseSpeed += 0.18
        }
        
        if GameData.levelData.day % 3 == 0 && GameData.levelData.day <= 20 {
            GameData.eggData.eggNog.baseDamage += 2
            GameData.eggData.eggNog.baseHealth += 6
            GameData.eggData.eggNog.baseSpeed += 0.1
            
        }
        
        if GameData.levelData.day % 5 == 0 && GameData.levelData.day < 30 {
            GameData.eggData.speedMultiplier += 0.07
            
        }
        
        //Every 10 days
        if GameData.levelData.day % 10 == 0 {
            GameData.levelData.maxEggs += 10
            GameData.eggData.healthMultiplier += 0.15
            GameData.eggData.speedMultiplier += 0.05
            
            GameData.playerData.tapBarIncreaseRate -= 0.01
        }
        
    }
    
}

