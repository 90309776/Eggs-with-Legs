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
    var maxEggs = GameData.levelData.maxEggs
    var eggArray: [Egg] = []
    var eggArrayNodes: [SKSpriteNode] = []
    var towerArray: [Tower] = []
    var projectileArray: [Projectile] = []
    var listOfEggTypes: [String] = ["BasicEgg", "RollingEgg", "EggNog", "BasicEgg", "RollingEgg", "BasicEgg"]
    var startGame = false
    
    
    //var listOfEggTypes: [String] = ["EggNog"]
    //var weaponSprite: SKSpriteNode!
    //var eggCountLabel: SKLabelNode!
    var fenceHealthLabel: SKLabelNode!
    //var tapCountLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var mainLayer: SKNode!
    var secondaryLayer: SKNode!
    
    var eggsCracked = 0
    var eggLayer: SKNode!
    
    var pauseLayer: SKNode!
    var unpauseButton: Button!
    var pauseMenuButton: Button!
    
    var sceneLabel: LabelSet!
    var pauseButton: Button!
    var pause: SKSpriteNode!
    var gameTimer = GameData.levelData.timeMax
    
    var player: Player!
    var fenceSprite: Fence!
    var tower_1: Tower!
    var tower_2: Tower!
    var sound: Sound!

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
        sound = Sound()
        initNodes() //initializes nodes such as various sprites and labels
        initObjects() //initizzes objects. //these are bootleg init functions
        //startDayTimer()
        //drawPlayableArea()
        scaleScene()
        if GameData.settingsData.music {
            sound.musicLoop(SoundName: "MainLoop")
        }
        
        print("\(maxEggs)")
        
        makePauseButton()
        introScene()
        
    }
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
    }
    
    func introScene() {
        let fadeIn = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.33), SKAction.wait(forDuration: 0.33)])
        let fadeOut = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.33), SKAction.wait(forDuration: 0.33)])
        sceneLabel.mainLabel.text = "Day: \(GameData.levelData.day)"
        sceneLabel.secondaryLabel.text = sceneLabel.mainLabel.text
        
        let runSequence = SKAction.sequence([SKAction.wait(forDuration: 2), fadeIn, SKAction.wait(forDuration: 3), fadeOut, SKAction.run {
            self.startDayTimer();
            self.startGame = true;
            }])
        sceneLabel.mainLabel.run(runSequence)
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
        let ranNum = Int.random(in: 0 ..< GameData.levelData.listOfEggs.count)
        let eggType = GameData.levelData.listOfEggs[ranNum]
        let egg: Egg
        //eggCount -= 1
        
        if eggType == "BasicEgg" {
            egg = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"), scene: self)
            egg.addEgg()
        } else if eggType == "RollingEgg" {
            egg = RollingEgg(sprite: SKSpriteNode(imageNamed: "rolling_egg_0"), scene: self)
            egg.addEgg()
        } else if eggType == "EggNog" {
            egg = EggNog(sprite: SKSpriteNode(imageNamed: "eggnog_0"), scene: self)
            egg.addEgg()
        } else if eggType == "RussianEgg" {
            egg = RussianEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"), scene: self)
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
        //checkTappedWeapon(touchLocation: touchLocation)
       
        checkTappedPause(touchLocation: touchLocation)
        checkTappedUnpause(touchLocation: touchLocation)
        checkTappedMenu(touchLocation: touchLocation)
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
        if spawnUpdateTime >= GameData.levelData.eggSpawnInterval && startGame && maxEggs > 0 {
            var ranSpawnAmount = Int.random(in: 0..<GameData.levelData.spawnAmountMaxNum)
            maxEggs -= 1
            print(maxEggs)
            //for amount in ranSpawnAmount
            
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
        if player.canTap && !(view?.scene?.isPaused)! {
            player.tapped()
            for egg in eggArray {
                if egg.sprite.contains(touchLocation) {
                    egg.health -= GameData.playerData.playerDamage
                    if egg.sprite.name == "RussianEgg" {
                        egg.addBabies()
                    }
                }
            }
        }
    }
    
//    func checkTappedWeapon(touchLocation: CGPoint) {
//        if weaponSprite.contains(touchLocation) {
//            player.animateCooldown()
//        }
//    }
    
    func checkTappedPause(touchLocation: CGPoint) {
        //print("ye")
        //let point = CGPoint(x: touchLocation.x, y: touchLocation.y - 100)
        if pauseButton.spriteButton.contains(touchLocation){
            print("touched")
            if !(scene!.view?.isPaused)! {
//                print("paused")
//                pause.texture = SKTexture(imageNamed: "button_play")
//                print(pauseButton.spriteButton.texture)
                pauseLayer.isHidden = false
                
                let sequence = SKAction.sequence([SKAction.run{
                    self.pause.texture = SKTexture(imageNamed: "button_play");
                    self.pauseLayer.isHidden = false
                    }, SKAction.wait(forDuration: 0.1), SKAction.run {
                        self.scene?.view?.isPaused = true
                    }])
                
                run(sequence)
                
                //scene?.view?.isPaused = true
            } else {
                scene!.view?.isPaused = false
                pause.texture = SKTexture(imageNamed: "button_pause")
                pauseLayer.isHidden = true
                //print(pauseButton.spriteButton.texture)
                //print("unpaused")
            }
        }
    }
    
    func checkTappedUnpause(touchLocation: CGPoint) {
        if unpauseButton.hasTouched(touchLocation: touchLocation) {
            scene!.view?.isPaused = false
            pause.texture = SKTexture(imageNamed: "button_pause")
            pauseLayer.isHidden = true
            print(pauseButton.spriteButton.texture)
            print("unpaused")
        }
    }
    
    func checkTappedMenu(touchLocation: CGPoint) {
        let reveal = SKTransition.fade(withDuration: 1.5)
        
        if pauseMenuButton.hasTouched(touchLocation: touchLocation) && !pauseLayer.isHidden {
            sound.stopMusic()
            print("")
            scene!.view?.isPaused = false
            let startScene = StartScene(fileNamed: "StartScene")
            startScene?.scaleMode = .aspectFill
            
            //startScene?.scaleMode = .aspectFill
            view!.presentScene(startScene!, transition: reveal)
        }
    }
    
    func checkWin() {
        let reveal = SKTransition.fade(withDuration: 3)
        if fenceSprite.health <= 0 {
            sound.stopMusic()
            fenceSprite!.sprite.texture = SKTexture(imageNamed: "fence-4")
            func fenceFallingScene() {
                let loseScene = LoseScene(fileNamed: "LoseScene")
                loseScene?.scaleMode = .aspectFill
                view!.presentScene(loseScene!, transition: reveal )
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
                fenceFallingScene()
                }]))
        } else if gameTimer == 0 {
            sound.stopMusic()
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.scaleMode = .aspectFill
            view!.presentScene(winScene!, transition: reveal )
        }
    }
    
    func updateLabels() {
        fenceHealthLabel.text = "\(fenceSprite.health)"
        coinsLabel.text = "\(GameData.playerData.coins)"
        //tapCountLabel.text = "Ammo: \(player.currentTapCount)/\(player.maxTapCount)"
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
    }
    
    func makePauseButton() {
        //pause = SKSpriteNode(color: UIColor.red, size: CGSize(width: 150, height: 150))
        pause = SKSpriteNode(imageNamed: "button_pause")
        pause.size = CGSize(width: 100, height: 100)
        pause.anchorPoint = CGPoint(x: 0, y: 0)
        pause.position = CGPoint(x: GameData.sceneScaling.playableAreaOrigin.x, y: GameData.sceneScaling.playableArea.height + pause.size.height - 5)
        pause.name = "pause"
        addChild(pause)
        pauseButton = Button(children: self.children, name: "pause")
        
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
        
        guard let pauseLayerNode = mainLayer.childNode(withName: "pauseLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.pauseLayer = pauseLayerNode
        
        pauseLayer.isHidden = true
        
        guard let eggLayerNode = childNode(withName: "eggLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.eggLayer = eggLayerNode
        
        guard let timerLabelNode = secondaryLayer.childNode(withName: "timerLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.timerLabel = timerLabelNode
        
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
        
//        guard let tapCountLabelNode = secondaryLayer.childNode(withName: "tapCountLabel") as? SKLabelNode else {
//            fatalError("tapCOuntLabel Nodes not loaded")
//        }
//        self.tapCountLabel = tapCountLabelNode
        
        guard let fenceSpriteNode = mainLayer.childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceSprite = Fence(sprite: fenceSpriteNode)
        
        
//        guard let weaponSpriteNode = secondaryLayer.childNode(withName: "weaponSprite") as? SKSpriteNode else {
//            fatalError("Label Nodes not loaded")
//        }
//        self.weaponSprite = weaponSpriteNode
        
//        guard let linearTowerNode = mainLayer.childNode(withName: "linearTowerSprite") as? SKSpriteNode else {
//            fatalError("Label Nodes not loaded")
//        }
        
        var tower1Sprite = SKSpriteNode(imageNamed: "tower_1")
        tower1Sprite.size = CGSize(width: 350, height: 350)
        tower1Sprite.position = CGPoint(x: GameData.sceneScaling.playableArea.maxX - 300, y: GameData.sceneScaling.playableAreaOrigin.y + 450)
        addChild(tower1Sprite)
        
        self.tower_1 = Tower(sprite: tower1Sprite, scene: self)
        tower_1.sprite.isHidden = true
        
//        guard let archTowerNode = mainLayer.childNode(withName: "archTowerSprite") as? SKSpriteNode else {
//            fatalError("Label Nodes not loaded")
//        }
        
        var tower2Sprite = SKSpriteNode(imageNamed: "tower_1")
        tower2Sprite.size = CGSize(width: 350, height: 350)
        tower2Sprite.position = CGPoint(x: GameData.sceneScaling.playableArea.maxX - 300, y: GameData.sceneScaling.playableAreaOrigin.y + 150)
        addChild(tower2Sprite)
        self.tower_2 = Tower(sprite: tower2Sprite, scene: self)
        tower_2.sprite.isHidden = true
        
        if GameData.towerData.tower_1Activated {
            tower_1.sprite.isHidden = false
        }
        if GameData.towerData.tower_2Activated {
            tower_2.sprite.isHidden = false
        }
        
        eggCount = GameData.levelData.maxEggs
    }
    
    func initObjects() {
        player = Player()
        
        addChild(player.tapBar.barBorder)
        sceneLabel = LabelSet(children: secondaryLayer.children, name: "sceneLabel")
        sceneLabel.mainLabel.isHidden = false
        sceneLabel.mainLabel.alpha = 0
        
        //pauseButton = Button(children: mainLayer.children, name: "pause")
        unpauseButton = Button(children: pauseLayer.children, name: "unpause")
        pauseMenuButton = Button(children: pauseLayer.children, name: "menu")
        
    }
    
}
