//
//  GameScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/4/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

/*
 BUG LIST
 1. Invincible Eggs
        DESC: Probably because the egg is being removed from the egg array
        and not being removed from the childnode.
        CAUSE: Possibly from eliminating an egg at the same time as the tower elims one
 
 2. [FIXED] Projectile still on screen and causing collision with other eggs [FIXED]
        CAUSE: Projectile is currently only removed from screen when it has been collided.
        So if the Egg the projectile is targeting was eliminated before the proj. hits, then
        projectile never gets removed.
 
 3. Int to Double changes (warning)
        DESC: Not a real bug, but may mess up or crash some stuff
 
*/

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var maxEggs = GameData.levelData.maxEggs
    var keepRunning = true
    var eggCount = 0
    
    var eggArray: [Egg] = []
    var projectileArray: [Projectile] = []
    
    //var basicEggAssets: [[SKTexture]] = [[]]
    var listOfEggTypes: [String] = ["BasicEgg"]
    
    var eggCountLabel: SKLabelNode!
    var fenceHealthLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var fenceSprite: Fence!
    
    var linearTowerSprite: Tower!
    var archTowerSprite: Tower!

    var lastUpdateTime : TimeInterval = 0
    var currentUpdateTime: TimeInterval = 0
    
    struct PhysicsCategory {
        static let none       : UInt32 = 0
        static let all        : UInt32 = 10
        static let egg        : UInt32 = 1      // 1
        static let fence      : UInt32 = 2      // 2
        static let projectile : UInt32 = 3
    }
    
    override func didMove(to view: SKView) {
        initNodes() //initializes nodes such as various sprites and labels
        
        run(
            SKAction.repeat(
                SKAction.sequence(
                    [SKAction.run(addEgg), SKAction.wait(forDuration: 1.0)]),
                count: GameData.levelData.maxEggs))
        print("max eggs start \(GameData.levelData.maxEggs)")
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
    }
    
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEgg() {
        let ranNum = Int.random(in: 0 ..< listOfEggTypes.count)
        let eggType = listOfEggTypes[ranNum]
        let egg: Egg
        
        if eggType == "BasicEgg" {
            egg = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"))
            egg.sprite.name = "egg"
            let actualY = random(min: 0 - size.height / 2 + egg.sprite.size.height, max: 275)
            egg.sprite.position = CGPoint(x: (0 - (size.width / 2) - egg.sprite.size.width), y: actualY)
            
            addChild(egg.sprite)
            egg.runAnimate()
            eggArray.append(egg)
        }
    }
    
    /*
     This function is called everytime 2 Sprites with defined Physics bodies collide (ie: egg and fence)
    */
    func didBegin(_ contact: SKPhysicsContact) {
        //print("2 time \(String(describing: contact.bodyB.node?.name))")
        let objectA = contact.bodyA.node as! SKSpriteNode
        let objectB = contact.bodyB.node as! SKSpriteNode
        
        //print("bodyA: \(String(describing: objectA.name))")
        //print("bodyB: \(String(describing: objectB.name))")
        //maybe encapsulate this for the egg object function
        //If the detected objects are fence and an egg then the egg is given a kicking animation
        if objectB.name == "egg" && objectA.name == "fenceSprite" {
            for (index, egg) in eggArray.enumerated() {
                //Want to rewrite so check if the object egg belongs to any of EggArray sprite
                //then manipulate that one instead of creating an entirly new tempegg
                if egg.sprite.position == objectB.position {
                    egg.sprite.removeFromParent()
                    let tempEgg = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"))
                    tempEgg.sprite.position = objectB.position
                    tempEgg.kickAnimate(fenceSprite: fenceSprite)
                    addChild(tempEgg.sprite)
                    eggArray[index] = tempEgg
                }
            }
        }
        //objectA.name == "projectile" && objectB.name?.range(of: "egg") != nil
        
        //checks if one object is a projectile and if the other object is a type of egg
        if  objectB.name == "projectile" && objectA.name?.range(of: "egg") != nil {
            //print("contact")
            //objectB.removeFromParent()
            for (index, egg) in eggArray.enumerated() {
                if egg.sprite == objectA && egg.hasContactProjectile == false {
                    egg.hasContactProjectile = true
                    //print("egg hp: \(egg.health)")
                    egg.health -= GameData.towerData.towerDamage
                    //print("egg hp after: \(egg.health)")
                    egg.checkDeathAnimate(index: index)
                    
                    
                }
            }
        } else if objectA.name == "projectile" && objectB.name?.range(of: "egg") != nil {
            //print("contact")
            //objectA.removeFromParent()
            for (index, egg) in eggArray.enumerated() {
                if egg.sprite == objectB  && egg.hasContactProjectile == false {
                    egg.hasContactProjectile = true
                    egg.health -= GameData.towerData.towerDamage
                    egg.checkDeathAnimate(index: index)
                    //objectB.removeFromParent()
                }
            }
        }
    }
    
    //Default function called when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        //Checks if an egg has been tapped
        for egg in eggArray {
            if egg.sprite.contains(touchLocation) {
                egg.health -= 5
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard let touch = touches.first else { return }
        //let touchLocation = touch.location(in: self)
        //print("\(touchLocation)")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkWin()
        updateLabels()
        fenceSprite.update()
        moveAndAnimateEgg()
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        currentUpdateTime += currentTime - lastUpdateTime
        //handles the 3 second intervals of a tower shooting
        if currentUpdateTime >= GameData.towerData.towerFireInterval {
            currentUpdateTime = 0
            if eggArray.count > 0 {
                linearTowerSprite.shootLinear(eggArray: eggArray)
                //linearTowerSprite.eliminateNear(eggArray: eggArray)
            }
        }
        self.lastUpdateTime = currentTime
    }
    
    
    /*
     Referenced functions from above below
    */
    
    func checkWin() {
        let reveal = SKTransition.fade(withDuration: 3)
        if fenceSprite.health <= 0 {
            GameData.levelData.day += 1
            let loseScene = LoseScene(fileNamed: "LoseScene")
            loseScene?.scaleMode = .aspectFill
            view!.presentScene(loseScene!, transition: reveal )
        } else if eggCount == GameData.levelData.maxEggs {
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.scaleMode = .aspectFill
            view!.presentScene(winScene!, transition: reveal )
        }
        
    }
    
    func updateLabels() {
        eggCountLabel.text = "Egg Count: \(eggCount)/\(GameData.levelData.maxEggs)"
        fenceHealthLabel.text = "Fence Health: \(fenceSprite.health)"
    }
    
    func moveAndAnimateEgg() {
        for (index, egg) in eggArray.enumerated() {
            if egg.health > 0.0 {
                egg.move()
                egg.checkCrackedRunAnimate()
            } else {
                /*
                 Removes the Egg's sprite current SKAction (the running animation)
                 If the Egg's health is 0 then the Egg's animateAction is set
                 to repeat the deathAnimation for the specific Egg type
                 Also runs the death animation a single time, once the animation
                 is completed, the Egg's Sprite will be removed from all nodes
                 */
                egg.checkDeathAnimate(index: index)
                eggCount += 1
                //egg.sprite.removeFromParent()
                eggArray.remove(at: index)
                
            }
            // checks if the Eggs are offscreen to the right, then will remove the egg
            if egg.sprite.position.x > size.width {
                egg.sprite.removeFromParent()
                eggArray.remove(at: index)
            }
        }
    }
    
    func initNodes() {
        guard let eggLabelNode = childNode(withName: "eggCountLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.eggCountLabel = eggLabelNode
        
        guard let dayLabelNode = childNode(withName: "dayLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.dayLabel = dayLabelNode
        dayLabel.text = "Day: \(GameData.levelData.day)"
        
        guard let fenceLabelNode = childNode(withName: "fenceHealthLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceHealthLabel = fenceLabelNode
        
        guard let fenceSpriteNode = childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceSprite = Fence(sprite: fenceSpriteNode)
        
        guard let linearTowerNode = childNode(withName: "linearTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.linearTowerSprite = Tower(sprite: linearTowerNode, scene: self)
        
        guard let archTowerNode = childNode(withName: "archTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.archTowerSprite = Tower(sprite: archTowerNode, scene: self)
    }
    
}
