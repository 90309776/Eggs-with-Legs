//
//  GameScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/4/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var maxEggs = 50
    var keepRunning = true
    var eggCount = 0
    
    var eggArray: [Egg] = []
    
    var basicEggAssets: [[SKTexture]] = [[]]
    var listOfEggTypes: [String] = ["BasicEgg"]
    
    var eggCountLabel: SKLabelNode!
    var fenceHealthLabel: SKLabelNode!
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
        //var fenceSprite: Fence!
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        
        initNodes() //initializes nodes such as various sprites and labels
        
        
        if keepRunning {
            run(
                SKAction.repeat(
                    SKAction.sequence(
                        [SKAction.run(addEgg), SKAction.wait(forDuration: 1.0)]),
                    count: maxEggs))
        }
//        linearTowerSprite.sprite.run(
//            SKAction.repeatForever(
//                SKAction.sequence(
//                    [SKAction.run(linearTowerSprite!.shootLinear(eggArray: eggArray)), SKAction.wait(forDuration: TimeInterval(linearTowerSprite.fireInterval))]
//        )))
        
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
            //egg.sprite.run(egg.animateAction, withKey: "run")
            egg.runAnimate()
            eggArray.append(egg)
    }
    

        //addChild(egg.sprite)
//        egg.sprite.run(egg.animateAction, withKey: "run")
        
        eggCount += 1
        //=============
        //commented out to use for reference later maybe
        //===========
        
//        egg.physicsBody = SKPhysicsBody(rectangleOf: egg.size) // 1
//        egg.physicsBody?.isDynamic = true // 2
//        egg.sprite.physicsBody?.categoryBitMask = PhysicsCategory.egg // 3
//        egg.sprite.physicsBody?.contactTestBitMask = PhysicsCategory.fence// 4
//        egg.sprite.physicsBody?.collisionBitMask = PhysicsCategory.fence // 5
        
        
//        print("actualY: \(actualY), min: \(egg.size.height), max: \(size.height)")
        
//
//        let speed = 20
//
//        let actioove = SKAction.move(to: CGPoint(x: egg.size.width + size.width, y: actualY), duration: TimeInterval(speed))
//        let actionMoveDone = SKAction.removeFromParent()
//        let loseAction = SKAction.run() { [weak self] in
//            guard let `self` = self else { return }
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
//        egg.run(SKAction.sequence([actionMove, actionMoveDone]))
    
    }
    
    /*
     This function is called everytime 2 Sprites with defined Physics bodies collide (ie: egg and fence)
    */
    func didBegin(_ contact: SKPhysicsContact) {
        //print("2 time \(String(describing: contact.bodyB.node?.name))")
        let objectA = contact.bodyA.node as! SKSpriteNode
        let objectB = contact.bodyB.node as! SKSpriteNode
        
        print("bodyA: \(String(describing: objectA.name))")
        print("bodyB: \(String(describing: objectB.name))")
        
        //If the detected objects are fence and an egg then the egg is given a kicking animation
        if objectB.name == "egg" && objectA.name == "fenceSprite" {
            for (index, egg) in eggArray.enumerated() {
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
            for (index, egg) in eggArray.enumerated() {
                if egg.sprite.position == objectA.position {
                    egg.health = 0
                    egg.checkDeathAnimate()
                    eggArray.remove(at: index)
                    objectB.removeFromParent()
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
        guard let touch = touches.first else { return }
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
        if currentUpdateTime >= 3 {
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
        if fenceSprite.health <= 0 {
            let loseScene = LoseScene(fileNamed: "LoseScene")
            loseScene?.scaleMode = .aspectFill
            
            
            let reveal = SKTransition.fade(withDuration: 3)
            view!.presentScene(loseScene!, transition: reveal )
            
        }
    }
    
    func updateLabels() {
        eggCountLabel.text = "Egg Count: \(eggCount)"
        fenceHealthLabel.text = "Fence Health: \(fenceSprite.health)"
    }
    
    func moveAndAnimateEgg() {
        for (index, egg) in eggArray.enumerated() {
            if egg.health > 0 {
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
                egg.checkDeathAnimate()
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
