//
//  Turret.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/15/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class Tower {
    
    var sprite: SKSpriteNode
    var gameScene: GameScene!
    
    init(sprite: SKSpriteNode, scene: GameScene) {
        self.sprite = sprite
        self.gameScene = scene
    }
    
    
    //THIS FUNCTION IS NOT BEING USED JUST FOR TESTING PURPOSES
    //test function to see to eliminate the closes egg to the tower
    func eliminateNear(eggArray: [Egg]) {
        var newEggArray = eggArray
        let removeIndex = findTargetIndex(eggArray: eggArray)
        //eggArray[removeIndex].sprite.removeFromParent()
        eggArray[removeIndex].health = 0
        //eggArray[removeIndex].checkDeathAnimate()
        newEggArray.remove(at: removeIndex)
        gameScene.eggArray = newEggArray
    }
    
    //function calculates the closes egg and creates a projectile to fire at the egg
    //in a linear direction
    func shootLinear(eggArray: [Egg]) {
        //move interval is .25
        let targetEgg = findTarget(eggArray: eggArray)
        //targetEgg.notAlive = false
//        var xLeading: CGFloat = 0
//        if targetEgg.name == "BasicEgg" {
//            xLeading = CGFloat(GameData.eggData.basicEgg.baseSpeed / 0.41)
//        } else if targetEgg.name == "RollingEgg" {
//            xLeading = CGFloat(GameData.eggData.rollingEgg.baseSpeed / 0.41)
//        } else if targetEgg.name == "EggNog"{
//            xLeading = CGFloat(GameData.eggData.eggNog.baseSpeed / 0.41)
//        }
        
        
        let adjustedTargetPoint = CGPoint(x: targetEgg.sprite.position.x + CGFloat(targetEgg.speed / 0.31), y: targetEgg.sprite.position.y)
        
        let projectile = Projectile(startPos: self.sprite.position, targetPos: adjustedTargetPoint, type: "projectile")
        projectile.sprite.size.height = 15
        projectile.sprite.size.width = 15
        gameScene.addChild(projectile.sprite)
        gameScene.projectileArray.append(projectile)
        projectile.projectileShootLinear(targetEgg: targetEgg)
        
        //gameScene.gunshot()
        
    }
    
    //goes through every egg of the egg array that is sent and sees which is closes
    //to the current tower position
    //returns an egg type
    func findTarget(eggArray: [Egg]) -> Egg {
        let towerPos = self.sprite.position
        //var shortestDistance = calcDistance(pointA: towerPos, pointB: eggArray[0].sprite.position)
        var shortestDistance = calcDistance(pointA: towerPos, pointB: eggArray[0].sprite.position)
        var shortestEggIndex = 0
        
        for (index, egg) in eggArray.enumerated() {
//          let testDistance = calcDistance(pointA: towerPos, pointB: egg.sprite.position)
            let testDistance = calcDistance(pointA: towerPos, pointB: egg.sprite.position)
            if  testDistance < shortestDistance {
                shortestDistance = testDistance
                shortestEggIndex = index
            }
        }
        return eggArray[shortestEggIndex]
    }
    
    //same as top but returns an index of the egg in the array
    //used for testing not currently being used for final game
    func findTargetIndex(eggArray: [Egg]) -> Int {
        let towerPos = self.sprite.position
        var shortestDistance = calcDistance(pointA: towerPos, pointB: eggArray[0].sprite.position)
        var shortestEggIndex = 0
        
        for (index, egg) in eggArray.enumerated() {
            let testDistance = calcDistance(pointA: towerPos, pointB: egg.sprite.position)
            if  testDistance < shortestDistance && !egg.notAlive{
                shortestDistance = testDistance
                shortestEggIndex = index
            }
        }
        return shortestEggIndex
    }
    
    func calcDistance(pointA: CGPoint, pointB: CGPoint ) -> CGFloat{
        let xDifference = pointB.x - pointA.x
        let yDIfference = pointB.y - pointA.y
        
        return CGFloat(sqrt(xDifference * xDifference + yDIfference * yDIfference))
    }
    
}
