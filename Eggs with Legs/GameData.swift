////
////  GameData.swift
////  Eggs with Legs
//
//  Created by 90309776 on 10/17/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

//class GameData: NSObject, NSCoding {
class GameData {

    //THIS IS THE DEFAULT DATA SET
    //IS MODIFIED AFTER A PASSING OF A DAY
    struct levelData {
        static var day = 1
        static var maxEggs = 10
        static var eggSpawnInterval: TimeInterval = 1
    }
    
    struct playerData {
        static var coins = 1000
        static var playerDamage = 5.0
        static var maxTapCount = 10
        static var cooldownInterval: TimeInterval = 3
    }
    
    struct towerData {
        static var towerFireInterval: TimeInterval = 3
        static var towerDamage = 5.0
    }
    
    struct eggData {
        
        struct basicEgg {
            static var baseSpeed = 10.0
            static var baseHealth = 10.0
            static var baseDamage = 1
        }
        
        struct rollingEgg {
            static var baseSpeed = 12.0
            static var constantRadianRotationRate: CGFloat = 22.5
            static var baseHealth = 5.0
            static var baseDamage = 3
        }

        
        static var speedMultiplier  = 1.0
        static var healthMultiplier = 1.0
        static var damageMultiplier = 1
    }
    
    struct fenceData {
        static var baseHealth = 1000
        static var healthMultiplier = 1
        static var fenceStage = 1
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
