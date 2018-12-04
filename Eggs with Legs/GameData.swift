////
////  GameData.swift
////  Eggs with Legs
//
//  Created by 90309776 on 10/17/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

/*
 These are basically super duper global variables.
 prob not good programming practice but it works.
 */

class GameData {

    //THIS IS THE DEFAULT DATA SET
    //IS MODIFIED AFTER A PASSING OF A DAY
    struct sceneScaling {
        static var playableArea: CGRect = CGRect()
        static var playableAreaOrigin: CGPoint = CGPoint()
        static var sceneYScale: CGFloat = 0.0
    }
    
    struct settingsData {
        static var vibration = true
        static var music = true
        
        static var hasPlayedTutorial = false
        
        static var songCurrentlyPlaying = [""]
        
    }
    
    struct levelData {
        static var timeMax = 30
        static var day = 1
        static var maxEggs = 1000
        static var eggSpawnInterval: TimeInterval = 1
        static var listOfEggs = ["BasicEgg"]
        
        static var spawnAmountMaxNum = 1
        
        static var highscore = UserDefaults.standard.value(forKey: "highscore")
    }
    
    struct playerData {
        static var coins = 0
        static var playerDamage = 5.0
        static var maxTapCount = 10
        static var cooldownInterval: TimeInterval = 3
        //0.01
        static var tapBarIncreaseRate = 0.13
        //static var tapBarDepletionRate = 0.0035
        static var tapBarDepletionRate = 0.0035
    }
    
    struct towerData {
        static var tower_1Activated = false
        static var tower_2Activated = false
        
        static var towerFireInterval: TimeInterval = 2.5
        static var towerDamage = 5.0
        
        
    }
    
    struct shopData {
        static var buyTowerCost = 1500
        static var upgradeTapBarCost = 200
        static var increaseTowerFireRateCost = 500
        static var upgradeFenceHealthCost = 250
        static var increasePlayerDamageCost = 500
        static var upgradeTowerDamageCost = 500
    }
    
    struct eggData {
        
        struct basicEgg {
            static var baseSpeed = 4.0
            static var baseHealth = 10.0
            static var baseDamage = 1
            static var coinRange = [20, 40]
        }
        
        struct eggNog {
            static var baseSpeed = 2.0
            static var baseHealth = 20.0
            static var baseDamage = 3
            static var coinRange = [20, 100]
        }
        
        struct rainbowEgg {
            static var baseSpeed = 4.0
            static var baseHealth = 15.0
            static var baseDamage = 2
            static var coinRange = [1, 150]
        }
        
        struct russianEgg {
            static var baseSpeed = 2.0
            static var baseHealth = 80.0
            static var baseDamage = 20
            static var coinRange = [100, 400]
            static var spawnAmount = 10
        }
        
        struct rollerbladingEgg {
            static var baseSpeed = 5.0
            static var baseHealth = 8.0
            static var baseDamage = 4
            static var coinRange = [50, 90]
        }
        
        struct rollingEgg {
            static var baseSpeed = 6.0
            static var constantRadianRotationRate: CGFloat = 22.5
            static var baseHealth = 5.0
            static var baseDamage = 3
            static var coinRange = [40, 70]
        }

        
        static var speedMultiplier  = 1.0
        static var healthMultiplier = 1.0
        static var damageMultiplier = 1
    }
    
    struct fenceData {
        static var baseHealth = 20
        static var healthMultiplier = 1
        static var fenceStage = 1
    }
    
    struct PhysicsCategory {
        static let none       : UInt32 = 0
        static let all        : UInt32 = 10
        static let egg        : UInt32 = 1
        static let fence      : UInt32 = 2
        static let projectile : UInt32 = 3
    }
    
    
    struct stats {
        static var totalEggsCracked = 0
        static var totalDamageTaken = 0
    }
    
    //This is prob really inefficient maybe replace if find new method
    static func saveLocalData() {
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
        
        print("Saved UserDefaults")
    }
    
    

//    var eggSpeed: Int
//    var fenceHealth: Int
//    var eggCount: Int
//
//    var dateOfScore: NSDate
//
//    init(eggSpeed: Int, fenceHealth: Int, eggCount: Int, dateOfScore: NSDate) {
//        self.eggSpeed = eggSpeed
//        self.fenceHealth = fenceHealth
//        self.eggCount = eggCount
//
//        self.dateOfScore = dateOfScore
//    }
//
//    func encode(with aCoder: NSCoder) {
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//
//    }






}
