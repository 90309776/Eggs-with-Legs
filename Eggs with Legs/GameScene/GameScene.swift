//
//  GameScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/4/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

/*
 BUG LIST
 1. [KINDA FIXED] Invincible Eggs [Happens less now.]
        DESC: Probably because the egg is being removed from the egg array
        and not being removed from the childnode.
        CAUSE: Possibly from eliminating an egg at the same time as the tower elims one
 
 2. [FIXED] Projectile still on screen and causing collision with other eggs [FIXED]
        CAUSE: Projectile is currently only removed from screen when it has been collided.
        So if the Egg the projectile is targeting was eliminated before the proj. hits, then
        projectile never gets removed.
 
 3. Some egg eliminations are not counting, therefore the level will not progress.
 
 4. Cracked Kicking Animation broken (basicEggs) [FiXED]
        DESC: If an egg is in cracked state before reaching the fence, once it reaches
        the fence, instead of changing to cracked kicking animation, it changes to
        normal egg kicking animation
 
 5. Game not removing Egg sprite from parent correctly
        DESC: When this happens, usually the egg is already been removed from the egg array.
        However the egg for some reason is not removed form the parent correctly. This causes
        The egg to still appear on the screen but not targettable, however it still was counted towards the
        total egg count goal.s
*/

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var keepRunning = true
    var eggCount = 0
    
    var eggArray: [Egg] = []
    var projectileArray: [Projectile] = []
    
    //var listOfEggTypes: [String] = ["BasicEgg", "RollingEgg"]
    var listOfEggTypes: [String] = ["BasicEgg"]
    var eggCountLabel: SKLabelNode!
    var fenceHealthLabel: SKLabelNode!
    var tapCountLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    
    
    var weaponSprite: SKSpriteNode!
    
    var player: Player!
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
        initObjects() //initizzes objects. //these are bootleg init functions
        run(
            SKAction.repeat(
                SKAction.sequence(
                    [SKAction.run(addEgg), SKAction.wait(forDuration: GameData.levelData.eggSpawnInterval)]),
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
            egg.sprite.name = eggType
            //egg.addEgg()
            let actualY = random(min: 0 - size.height / 2 + egg.sprite.size.height, max: 275)
            egg.sprite.position = CGPoint(x: (0 - (size.width / 2) - egg.sprite.size.width), y: actualY)
            egg.sprite.scale(to: CGSize(width: 300, height: 300))
            addChild(egg.sprite)
            egg.runAnimate()
            eggArray.append(egg)
        } else if eggType == "RollingEgg" {
            egg = RollingEgg(sprite: SKSpriteNode(imageNamed: "rolling_egg_0"))
            //egg.addEgg()
            addChild(egg.sprite)
            egg.sprite.name = eggType
            let actualY = random(min: 0 - size.height / 2 + egg.sprite.size.height + 30, max: 250)
            egg.sprite.position = CGPoint(x: (0 - (size.width / 2) - egg.sprite.size.width), y: actualY)
            egg.sprite.scale(to: CGSize(width: 300, height: 300))
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
        
       // print("bodyA: \(String(describing: objectA.name))")
       // print("bodyB: \(String(describing: objectB.name))")
        //maybe encapsulate this for the egg object function
        //If the detected objects are fence and an egg then the egg is given a kicking animation
        if objectB.name?.range(of: "Egg") != nil && objectA.name == "fenceSprite" {
            for (index, egg) in eggArray.enumerated() {
                //Want to rewrite so check if the object egg belongs to any of EggArray sprite
                //then manipulate that one instead of creating an entirly new tempegg
                if egg.sprite == objectB && egg.hasContactFence == false{
                    egg.hasContactFence = true
                    egg.kickAnimate(fenceSprite: fenceSprite)
                    
                    //addChild(tempEgg.sprite)
                    //eggArray[index] = tempEgg
                }
            }
        }
        //lots of things are broken with kicking animation remember to fix
        //lots of things are broken with kicking animation remember to fix
        //lots of things are broken with kicking animation remember to fix
        //lots of things are broken with kicking animation remember to fix
        
        if  objectB.name == "projectile" && objectA.name?.range(of: "Egg") != nil {
            for (index, egg) in eggArray.enumerated() {
                if egg.sprite == objectA && egg.hasContactProjectile == false {
                    egg.hasContactProjectile = true
                    egg.health -= GameData.towerData.towerDamage
                    egg.checkDeathAnimate(index: index)
                    
                    
                }
            }
        } else if objectA.name == "projectile" && objectB.name?.range(of: "Egg") != nil {
            for (index, egg) in eggArray.enumerated() {
                if egg.sprite == objectB  && egg.hasContactProjectile == false {
                    egg.hasContactProjectile = true
                    egg.health -= GameData.towerData.towerDamage
                    egg.checkDeathAnimate(index: index)
                }
            }
        }
    }
    
    //Default function called when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
         //Checks if an egg has been tapped
        if player.currentTapCount > 0 {
            player.tapped()
            for egg in eggArray {
                
                if egg.sprite.contains(touchLocation) {
                    //player.tappedEgg(egg: egg)
                    egg.health -= GameData.playerData.playerDamage
                }
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
        player.update()
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        currentUpdateTime += currentTime - lastUpdateTime
        //handles the 3 second intervals of a tower shooting
        //later on make this abstract and belong to the tower class itself
        //because we want to have multiple towers
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
            fenceSprite!.sprite.texture = SKTexture(imageNamed: "fence-4")
            //fenceSprite!.sprite.zRotation
            func fenceFallingScene() {
                let loseScene = LoseScene(fileNamed: "LoseScene")
                loseScene?.scaleMode = .aspectFill
                view!.presentScene(loseScene!, transition: reveal )
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
                fenceFallingScene()
                }]))
            //GameData.levelData.day += 1
            //fenceSprite!.changeSprite()
            //SKAction.wait(forDuration: 4)
            
        } else if eggCount == GameData.levelData.maxEggs {
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.scaleMode = .aspectFill
            view!.presentScene(winScene!, transition: reveal )
        }
        
    }
    
    func updateLabels() {
        eggCountLabel.text = "Egg Count: \(eggCount)/\(GameData.levelData.maxEggs)"
        fenceHealthLabel.text = "Fence Health: \(fenceSprite.health)"
        coinsLabel.text = "Coins: \(GameData.playerData.coins)"
        tapCountLabel.text = "Taps: \(player.currentTapCount)"
    }
    
    func moveAndAnimateEgg() {
        for (index, egg) in eggArray.enumerated() {
            if egg.health > 0.0 {
                egg.move()
                egg.checkCrackedRunAnimate()
                egg.checkCrackedKickAnimate(fenceSprite: fenceSprite)
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
                if eggArray.count > index + 1{
                    eggArray.remove(at: index)
                }
                
                
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
        
        guard let coinsLabelNode = childNode(withName: "coinsLabel") as? SKLabelNode else {
            fatalError("coinsLabelNode Nodes not loaded")
        }
        self.coinsLabel = coinsLabelNode
        
        guard let tapCountLabelNode = childNode(withName: "tapCountLabel") as? SKLabelNode else {
            fatalError("tapCOuntLabel Nodes not loaded")
        }
        self.tapCountLabel = tapCountLabelNode
        
        guard let fenceSpriteNode = childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceSprite = Fence(sprite: fenceSpriteNode)
        
        guard let weaponSpriteNode = childNode(withName: "weaponSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.weaponSprite = weaponSpriteNode
        
        guard let linearTowerNode = childNode(withName: "linearTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.linearTowerSprite = Tower(sprite: linearTowerNode, scene: self)
        
        guard let archTowerNode = childNode(withName: "archTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.archTowerSprite = Tower(sprite: archTowerNode, scene: self)
    }
    
    func initObjects() {
        player = Player(sprite: weaponSprite)
    }
    
}
