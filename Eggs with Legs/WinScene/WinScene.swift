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
    var increasePlayerDamageSprite: SKSpriteNode!
    var damageCountLabel: SKLabelNode!
    var nextLevelButton: SKSpriteNode!
    
    var increaseTowerFireRateSprite: SKSpriteNode!
    var fireRateLabel: SKLabelNode!
    
    var coinSprite: SKSpriteNode!
    var coinAmountLabel: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        
        initNodes()
    }
    
    override func sceneDidLoad() {
        
    }//
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        //print("\(touchLocation)")
        pressedNextButton(touchLocation: touchLocation)
        pressedIncreasePlayerDamageButton(touchLocation: touchLocation)
        pressedIncreaseFireRateButton(touchLocation: touchLocation)
        
        
    }
    
    
    /*
     REFERENCED FUNCTIONS ARE BELOW
     */
    
    
    
    func pressedIncreaseFireRateButton(touchLocation: CGPoint) {
        if increaseTowerFireRateSprite.contains(touchLocation) {
            if GameData.towerData.towerFireInterval > 0.5 {
                GameData.towerData.towerFireInterval -= 0.20
                print("fire rate: \(GameData.towerData.towerFireInterval)")
            }
        }
    }
    
    func pressedIncreasePlayerDamageButton(touchLocation: CGPoint) {
        if increasePlayerDamageSprite.contains(touchLocation) {
            GameData.playerData.playerDamage += 1
            damageCountLabel.text = String(Int(GameData.playerData.playerDamage))
            //print(String(Int(GameData.playerData.playerDamage)))
        }
    }
    
    
    func pressedNextButton(touchLocation: CGPoint) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
       // print("called")
        //

        
        
        if  nextLevelButton.contains(touchLocation){
            print("exec")
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

    
    
    func initNodes() {

        guard let nextLevelNode = childNode(withName: "nextLevelSprite") as? SKSpriteNode else {
            fatalError("nextBUttonPSriteNode failed to load. Maybe not in childNode list?")
        }
        self.nextLevelButton = nextLevelNode
        
        guard let mainShopNode = childNode(withName: "mainShopSprite") as? SKSpriteNode else {
            fatalError("mainShopNode failed to load. Maybe not in childNode list?")
        }
        self.mainShopSprite = mainShopNode
        
        guard let increasePlayerDamageNode = childNode(withName: "increasePlayerDamageSprite") as? SKSpriteNode else {
            fatalError("nextBUttonPSriteNode failed to load. Maybe not in childNode list?")
        }
        self.increasePlayerDamageSprite = increasePlayerDamageNode
        
        guard let damageLabelNode = increasePlayerDamageSprite.childNode(withName: "damageLabel") as? SKLabelNode else {
            fatalError("damageNode failed to load. Maybe not in childNode list?")
        }
        
        self.damageCountLabel = damageLabelNode
        self.damageCountLabel.text = String(Int(GameData.playerData.playerDamage))
        
        guard let coinLabelNode = mainShopSprite.childNode(withName: "coinAmountLabel") as? SKLabelNode else {
            fatalError("coinlabelnode failed to load. Maybe not in childNode list?")
        }
        self.coinAmountLabel = coinLabelNode
        self.coinAmountLabel.text = String(Int(GameData.playerData.coins))
        
        guard let increaseFireRateSpriteNode = childNode(withName: "increaseTowerFireRateButton") as? SKSpriteNode else {
            fatalError("fire rate button failed to load. Maybe not in childNode list?")
        }
        self.increaseTowerFireRateSprite = increaseFireRateSpriteNode
        
        guard let fireRateNode = increaseTowerFireRateSprite.childNode(withName: "fireRateAmountLabel") as? SKLabelNode else {
            fatalError("coinlabelnode failed to load. Maybe not in childNode list?")
        }
        self.fireRateLabel = fireRateNode
        self.fireRateLabel.text = String(1 / GameData.towerData.towerFireInterval)
        
    }

}

