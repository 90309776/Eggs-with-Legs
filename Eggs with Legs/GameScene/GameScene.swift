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
    //Shoutout to global variables
    var eggCount = 0
    
    var eggArray: [Egg] = []
    var eggArrayNodes: [SKSpriteNode] = []
    var towerArray: [Tower] = []
    var projectileArray: [Projectile] = []
    var listOfEggTypes: [String] = ["BasicEgg", "RollingEgg"]
    
    //var listOfEggTypes: [String] = ["RollingEgg"]
    var weaponSprite: SKSpriteNode!
    var eggCountLabel: SKLabelNode!
    var fenceHealthLabel: SKLabelNode!
    var tapCountLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var mainLayer: SKNode!
    var secondaryLayer: SKNode!
    
    var gameTimer = GameData.levelData.timeMax
    
    var player: Player!
    var fenceSprite: Fence!
    var tower_1: Tower!
    var tower_2: Tower!

    var lastUpdateTime : TimeInterval = 0
    var spawnUpdateTime: TimeInterval = 0
    var towerUpdateTime: TimeInterval = 0
    
    struct PhysicsCategory {
        static let none       : UInt32 = 0
        static let all        : UInt32 = 10
        static let egg        : UInt32 = 1
        static let fence      : UInt32 = 2
        static let projectile : UInt32 = 3
    }
    
    override func didMove(to view: SKView) {
        initNodes() //initializes nodes such as various sprites and labels
        initObjects() //initizzes objects. //these are bootleg init functions
        startDayTimer()
        drawPlayableArea()
        scaleScene()
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
    }
    
    func startDayTimer() {
        let waitTime = SKAction.wait(forDuration: 1)
        let timerAction = SKAction.run {
            if self.gameTimer > 0 {
                self.gameTimer -= 1
            } else {
                self.removeAction(forKey: "timer")
            }
        }
        let timerSequence = SKAction.sequence([waitTime, timerAction])
        run(SKAction.repeatForever(timerSequence), withKey: "timer")
    }
    //Adds the egg to the scene
    //Egg type is random based on the listOfEggTypes array
    func addEgg() {
        let ranNum = Int.random(in: 0 ..< listOfEggTypes.count)
        let eggType = listOfEggTypes[ranNum]
        let egg: Egg
        
        if eggType == "BasicEgg" {
            egg = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"), scene: self)
            egg.addEgg()
        } else if eggType == "RollingEgg" {
            egg = RollingEgg(sprite: SKSpriteNode(imageNamed: "rolling_egg_0"), scene: self)
            egg.addEgg()
        }
    }
    
    //This function is called everytime 2 Sprites with defined Physics bodies collide (ie: egg and fence)
    func didBegin(_ contact: SKPhysicsContact) {
        let objectA = contact.bodyA.node as! SKSpriteNode
        let objectB = contact.bodyB.node as! SKSpriteNode
        
        //print("body A: \(String(describing: objectA.name))")
        //print("bodyB: \(String(describing: objectB.name))")
        
        //Checks collision between an egg and the fence
        if objectB.name?.range(of: "Egg") != nil && objectA.name == "fenceSprite" {
            for (_, egg) in eggArray.enumerated() {
                if egg.sprite == objectB && !egg.hasContactFence {
                    egg.hasContactFence = true
                    egg.kickAnimate(fenceSprite: fenceSprite)
                }
            }
        }
        
        //Checks the collision between an egg and a projectile
        if  objectB.name == "projectile" && objectA.name?.range(of: "Egg") != nil {
            for (_, egg) in eggArray.enumerated() {
                for (index, projectile) in projectileArray.enumerated() {
                    if egg.sprite == objectA && projectile.sprite == objectB && !projectile.hasContactEgg {
                        projectile.hasContactEgg = true
                        egg.health -= GameData.towerData.towerDamage
                        projectileArray.remove(at: index)
                    }
                }
            }
        } else if objectA.name == "projectile" && objectB.name?.range(of: "Egg") != nil {
            for (_, egg) in eggArray.enumerated() {
                for (index, projectile) in projectileArray.enumerated() {
                    if egg.sprite == objectB && projectile.sprite == objectA && !projectile.hasContactEgg{
                        projectile.hasContactEgg = true
                        egg.health -= GameData.towerData.towerDamage
                        projectileArray.remove(at: index)
                    }
                }
            }
        }
    }
    
    //Default function called when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        checkTappedEgg(touchLocation: touchLocation)
        checkTappedWeapon(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //Update function is called every frame. 60times per second
    override func update(_ currentTime: TimeInterval) {
        checkWin()
        updateLabels()
        fenceSprite.update()
        moveAndCheckEgg()
        player.update()
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        towerUpdateTime += currentTime - lastUpdateTime
        //handles the 3 second intervals of a tower shooting
        //later on make this abstract and belong to the tower class itself
        //because we want to have multiple towers
        if towerUpdateTime >= GameData.towerData.towerFireInterval {
            towerUpdateTime = 0
            if eggArray.count > 0 {
                if GameData.towerData.tower_1Activated {
                    tower_1.shootLinear(eggArray: eggArray)
                }
                if GameData.towerData.tower_2Activated {
                    tower_2.shootLinear(eggArray: eggArray)
                }
            }
        }

        spawnUpdateTime += currentTime - lastUpdateTime
        if spawnUpdateTime >= GameData.levelData.eggSpawnInterval {
            addEgg()
            spawnUpdateTime = 0
        }
        self.lastUpdateTime = currentTime
    }
    
    /*
     Referenced functions from above below
    */
    
    
    func checkTappedEgg(touchLocation: CGPoint) {
        //Checks if an egg has been tapped
        if player.currentTapCount > 0 && player.canFire {
            player.tapped()
            for egg in eggArray {
                if egg.sprite.contains(touchLocation) {
                    egg.health -= GameData.playerData.playerDamage
                }
            }
        }
    }
    
    func checkTappedWeapon(touchLocation: CGPoint) {
        if weaponSprite.contains(touchLocation) {
            player.animateCooldown()
        }
    }
    
    func checkWin() {
        let reveal = SKTransition.fade(withDuration: 3)
        if fenceSprite.health <= 0 {
            fenceSprite!.sprite.texture = SKTexture(imageNamed: "fence-4")
            func fenceFallingScene() {
                let loseScene = LoseScene(fileNamed: "LoseScene")
                loseScene?.scaleMode = .aspectFill
                view!.presentScene(loseScene!, transition: reveal )
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
                fenceFallingScene()
                }]))
            //eggCount == GameData.levelData.maxEggs
        } else if gameTimer == 0 {
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.scaleMode = .aspectFill
            view!.presentScene(winScene!, transition: reveal )
        }
    }
    
    func updateLabels() {
        eggCountLabel.text = "Egg Count: \(eggCount)/\(GameData.levelData.maxEggs)"
        fenceHealthLabel.text = "Fence Health: \(fenceSprite.health)"
        coinsLabel.text = "Coins: \(GameData.playerData.coins)"
        tapCountLabel.text = "Ammo: \(player.currentTapCount)"
        timerLabel.text = "\(gameTimer)s"
    }
    
    func moveAndCheckEgg() {
        for (index, egg) in eggArray.enumerated() {
            if egg.health > 0.0 {
                egg.move()
                egg.checkCrackedRunAnimate()
                egg.checkCrackedKickAnimate(fenceSprite: fenceSprite)
                egg.checkShowHealthBar()
            } else {
                /*
                 Removes the Egg's sprite current SKAction (the running animation)
                 If the Egg's health is 0 then the Egg's animateAction is set
                 to repeat the deathAnimation for the specific Egg type
                 Also runs the death animation a single time, once the animation
                 is completed, the Egg's Sprite will be removed from all nodes
                 */
                if egg.animationState != "death" {
                    //eggCount += 1
                    //print(eggCount)
                }
                egg.checkDeathAnimate(index: index)
            }
            // checks if the Eggs are offscreen to the right, then will remove the egg
//            if egg.sprite.position.x > size.width {
//                egg.sprite.removeFromParent()
//                eggArray.remove(at: index)
//            }
        }
    }
    
    func drawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(GameData.sceneScaling.playableArea)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 8
        addChild(shape)
        //print("shape pos: \(shape.position)")
    }
    
    func scaleScene() {
        //Scales the scene to fit any iPhone. Causes some distortion horizontally
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
    func initNodes() {
        
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.mainLayer = mainLayerNode
        
        guard let secondaryLayerNode = mainLayer.childNode(withName: "secondaryLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.secondaryLayer = secondaryLayerNode
        
        guard let timerLabelNode = secondaryLayer.childNode(withName: "timerLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.timerLabel = timerLabelNode
        
        guard let eggLabelNode = secondaryLayer.childNode(withName: "eggCountLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.eggCountLabel = eggLabelNode
        
        guard let dayLabelNode = secondaryLayer.childNode(withName: "dayLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.dayLabel = dayLabelNode
        dayLabel.text = "Day: \(GameData.levelData.day)"
        
        guard let fenceLabelNode = secondaryLayer.childNode(withName: "fenceHealthLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceHealthLabel = fenceLabelNode
        
        guard let coinsLabelNode = secondaryLayer.childNode(withName: "coinsLabel") as? SKLabelNode else {
            fatalError("coinsLabelNode Nodes not loaded")
        }
        self.coinsLabel = coinsLabelNode
        
        guard let tapCountLabelNode = secondaryLayer.childNode(withName: "tapCountLabel") as? SKLabelNode else {
            fatalError("tapCOuntLabel Nodes not loaded")
        }
        self.tapCountLabel = tapCountLabelNode
        
        guard let fenceSpriteNode = mainLayer.childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceSprite = Fence(sprite: fenceSpriteNode)
        
        guard let weaponSpriteNode = secondaryLayer.childNode(withName: "weaponSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.weaponSprite = weaponSpriteNode
        
        guard let linearTowerNode = mainLayer.childNode(withName: "linearTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.tower_1 = Tower(sprite: linearTowerNode, scene: self)
        
        guard let archTowerNode = mainLayer.childNode(withName: "archTowerSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.tower_2 = Tower(sprite: archTowerNode, scene: self)
    }
    
    func initObjects() {
        player = Player(sprite: weaponSprite)
    }
    
}
