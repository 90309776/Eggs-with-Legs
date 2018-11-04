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
    
    var shopLayer: SKNode!
    
    var mainShopSprite: SKSpriteNode!
    var nextLevelButton: SKSpriteNode!
    
    var coinSprite: SKSpriteNode!
    var coinAmountLabel: SKLabelNode!
    
    
    var increasePlayerDamageButton:     ShopButton!
    var increaseTowerFireRateButton:    ShopButton!
    var upgradeFenceButton:      ShopButton!
    var upgradeWeaponButton:      ShopButton!
    var buyTowerButton: ShopButton!
    
    
    
    
    override func didMove(to view: SKView) {
        initNodes()
        initObjects()
    }
    
    override func sceneDidLoad() {
        
    }//
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        pressedNextButton(touchLocation: touchLocation)
        pressedIncreasePlayerDamageButton(touchLocation: touchLocation)
        pressedIncreaseFireRateButton(touchLocation: touchLocation)
        pressedUpgradeFenceButton(touchLocation: touchLocation)
        pressedUpgradeWeaponButton(touchLocation: touchLocation)
        pressedBuyTowerButton(touchLocation: touchLocation)
        
    }
    
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
            GameData.eggData.basicEgg.baseSpeed += 1
            
            GameData.eggData.rollingEgg.baseDamage += 3
            GameData.eggData.rollingEgg.baseSpeed += 2
        }
        
        if GameData.levelData.day % 5 == 0 && GameData.levelData.day < 30 {
            GameData.eggData.speedMultiplier += 0.25
            
        }
        
        //Every 10 days
        if GameData.levelData.day % 10 == 0 {
            GameData.levelData.maxEggs += 10
            GameData.eggData.healthMultiplier += 0.15
            GameData.eggData.speedMultiplier += 0.10
        }
        
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
                
                GameData.shopData.increaseTowerFireRateCost += 100
            }
        }
    }
    
    func pressedIncreasePlayerDamageButton(touchLocation: CGPoint) {
        if increasePlayerDamageButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.increasePlayerDamageCost {
            GameData.playerData.coins -= GameData.shopData.increasePlayerDamageCost
            GameData.playerData.playerDamage += 2
            increasePlayerDamageButton.secondaryLabel.text = "Dmg: \(String(Int(GameData.playerData.playerDamage)))"
            
            GameData.shopData.increasePlayerDamageCost += 150
        }
    }
    
    func pressedUpgradeWeaponButton(touchLocation: CGPoint) {
        if upgradeWeaponButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeWeaponCost {
            GameData.playerData.coins -= GameData.shopData.upgradeWeaponCost
            GameData.playerData.maxTapCount += 4
            if GameData.playerData.cooldownInterval >= 0.5 {
                GameData.playerData.cooldownInterval -= 0.25
            }
            
            GameData.shopData.upgradeWeaponCost += 100
        }
    }
    
    func pressedUpgradeFenceButton(touchLocation: CGPoint) {
        if upgradeFenceButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.upgradeFenceHealthCost {
            GameData.playerData.coins -= GameData.shopData.upgradeFenceHealthCost
            GameData.fenceData.baseHealth += 20
            
            GameData.shopData.upgradeFenceHealthCost += 150
        }
    }
    
    func pressedBuyTowerButton(touchLocation: CGPoint) {
        if buyTowerButton.spriteButton.contains(touchLocation) && GameData.playerData.coins >= GameData.shopData.buyTowerCost {
            if GameData.towerData.tower_1Activated == false {
                GameData.playerData.coins -= GameData.shopData.buyTowerCost
                GameData.towerData.tower_1Activated = true
                
                GameData.shopData.buyTowerCost += 3000
                buyTowerButton.descLabel.text = "+1 Tower (1/2)"
            } else if GameData.towerData.tower_2Activated == false {
                GameData.playerData.coins -= GameData.shopData.buyTowerCost
                GameData.towerData.tower_2Activated = true
                
                GameData.shopData.buyTowerCost = 0
                buyTowerButton.descLabel.text = "+0 Tower (2/2)"
                
                buyTowerButton.spriteButton.isHidden = true
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
    
    func updateLabels() {
        coinAmountLabel.text = String(GameData.playerData.coins)
        
        increaseTowerFireRateButton.costLabel.text = String(GameData.shopData.increaseTowerFireRateCost)
        increasePlayerDamageButton.costLabel.text = String(GameData.shopData.increasePlayerDamageCost)
        upgradeFenceButton.costLabel.text = String(GameData.shopData.upgradeFenceHealthCost)
        upgradeWeaponButton.costLabel.text = String(GameData.shopData.upgradeWeaponCost)
        buyTowerButton.costLabel.text = String(GameData.shopData.buyTowerCost)
    }
    
    
    func initNodes() {
        guard let nextLevelNode = childNode(withName: "nextLevelSprite") as? SKSpriteNode else {
            fatalError("nextBUttonPSriteNode failed to load. Maybe not in childNode list?")
        }
        self.nextLevelButton = nextLevelNode
        
        guard let mainShopNode = childNode(withName: "mainShopSprite") as? SKSpriteNode else {
            fatalError("mainShopNode failed to load. Maybe not in childNode list?")
        }
        self.mainShopSprite = mainShopNode
        
        guard let coinLabelNode = mainShopSprite.childNode(withName: "coinAmountLabel") as? SKLabelNode else {
            fatalError("coinlabelnode failed to load. Maybe not in childNode list?")
        }
        self.coinAmountLabel = coinLabelNode
        self.coinAmountLabel.text = String(Int(GameData.playerData.coins))
    }
    
    func initObjects() {
        increasePlayerDamageButton = ShopButton(children: children, name: "increasePlayerDamageSprite")
        increaseTowerFireRateButton = ShopButton(children: children, name: "increaseTowerFireRateButton")
        upgradeWeaponButton = ShopButton(children: children, name: "upgradeWeaponButton")
        upgradeFenceButton = ShopButton(children: children, name: "upgradeFenceButton")
        buyTowerButton = ShopButton(children: children, name: "buyTowerButton")
        
        
    }
}

