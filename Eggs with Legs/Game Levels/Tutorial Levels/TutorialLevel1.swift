//
//  TutorialLevel1.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/17/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class TutorialLevel1: GameScene {
    //Shoutout to global variables

    var tutorialStart = false
    var checkForAnAction = false
    var nextStageReady = false
    var tutorialLayer: SKNode!
    var tutorialLabel: LabelSet!
    var tutorialLabel2: LabelSet!
    //var sound: Sound!
    var touched = false
    
    var secretSkipTimeCounter: TimeInterval = 0
    
    var eggSpawnInterval: TimeInterval = 3
    
    var arrow: SKSpriteNode!
    
    var fingerTap: SKSpriteNode!
    //var maxEggs = 4

    var tutorialStage = 1
    
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
        tutorialSetup()
        scaleScene()
        stage1()
        maxEggs = 4
        
        if GameData.settingsData.music {
            sound.musicLoop(SoundName: "GetTheWater")
        }
        
    }
    
    
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
    }
    
    func tutorialSetup() {
        self.listOfEggTypes = ["BasicEgg"]
    }
    
    /*
     These stage functions are the scripted events that are ran in the tutorial stage
     Outside of these stage functions are checks to see specific events that are asked to be performed
     by the stages, or checks to see if a stage is finished to continue onto another one.
    */
    
    
    var fadeTutorialMessageInAction = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.2), SKAction.wait(forDuration: 0.2)])
    var fadeTutorialMessageOutAction = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.wait(forDuration: 0.2)])
    func stage1() {
        tutorialLabel.mainLabel.text = "Eggs are attacking!"
        
        let message1 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "Eggs are attacking!"
        }, SKAction.wait(forDuration: 6), fadeTutorialMessageOutAction])
        
        let message2 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "Quick, protect your farm!"
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 4), fadeTutorialMessageOutAction,
               SKAction.run {
                self.tutorialStart = true
            }])
        let runSequence = SKAction.sequence([fadeTutorialMessageInAction, message1, message2])
        tutorialLabel.mainLabel.run(runSequence)
    }
    
    func stage2() {
        let arrowFadeOut = SKAction.sequence([SKAction.fadeAlpha(to: 0.3, duration: 0.2), SKAction.wait(forDuration: 0.2)])
        self.arrow.isHidden = false
        let arrowAction = SKAction.repeatForever(SKAction.sequence([fadeTutorialMessageInAction, arrowFadeOut]))
        
        let hideArrowAction = SKAction.run {
            self.arrow.isHidden = true
        }
        
        let stageFinishedAction = SKAction.run {
            self.nextStageReady = true
        }
        
        self.tutorialLabel2.mainLabel.text = "This is your tap meter."
        let message1 = SKAction.sequence([SKAction.run {
            self.tutorialLabel2.mainLabel.text = "This is your tap meter."; self.arrow.run(arrowAction)
            }, SKAction.wait(forDuration: 3), fadeTutorialMessageOutAction])
        
        let message2 = SKAction.sequence([SKAction.run {
            self.tutorialLabel2.mainLabel.text = "Tapping to fast increases the meter."
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 3), fadeTutorialMessageOutAction])
        
        let sampleCooldown = SKAction.run {
            self.player.tapBar.bar.size.width = CGFloat(self.player.tapBar.barMaxWidth)
            self.player.animateCooldown()
        }
        
        let message3 = SKAction.sequence([SKAction.run {
            self.tutorialLabel2.mainLabel.text = "If the meter overflows, then taps are on cooldown"
            }, fadeTutorialMessageInAction,sampleCooldown ,SKAction.wait(forDuration: 5), hideArrowAction, stageFinishedAction, fadeTutorialMessageOutAction, SKAction.wait(forDuration: 3)])

        let runSequence = SKAction.sequence([fadeTutorialMessageInAction, message1, message2, message3])
        tutorialLabel2.mainLabel.run(runSequence)
    }
    
    func stage3() {
        
        let arrowFadeOut = SKAction.sequence([SKAction.fadeAlpha(to: 0.3, duration: 0.2), SKAction.wait(forDuration: 0.2)])
        self.arrow.isHidden = false
        let arrowAction = SKAction.repeatForever(SKAction.sequence([fadeTutorialMessageInAction, arrowFadeOut]))
        
        self.fenceHealthLabel.isHidden = false
        self.coinsLabel.isHidden = false
        self.arrow.position = CGPoint(x: fenceSprite.sprite.position.x - 300, y: fenceSprite.sprite.size.height / 2)
        
        self.tutorialLabel.mainLabel.text = "This is your only defense."
        let message1 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "This is your only defense."; self.arrow.run(arrowAction)
            }, SKAction.wait(forDuration: 4), fadeTutorialMessageOutAction])
        
        let moveArrow = SKAction.run {
            self.arrow.position = CGPoint(x: self.fenceHealthLabel.position.x - 100, y: self.fenceHealthLabel.position.y - 400 / 2); self.arrow.zRotation = 90
        }
        
        let message2 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "Egg are trying to break through your fence."
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 4), moveArrow, fadeTutorialMessageOutAction])
        
        
        
        let message3 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "This is your fence's current health."
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 3), fadeTutorialMessageOutAction])
        
        let moveArrow2 = SKAction.run {
            self.arrow.position = CGPoint(x: self.coinsLabel.position.x, y: self.coinsLabel.position.y - 400 / 2)
        }
        
        let message4 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "If it falls to 0, the eggs will take over!"
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 3), moveArrow2, fadeTutorialMessageOutAction])
        
        
        let message5 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "These are your coins."
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 3), fadeTutorialMessageOutAction])
        
        let hideArrowAction = SKAction.run {
            self.arrow.isHidden = true
        }
        
        let stageFinishedAction = SKAction.run {
            self.nextStageReady = true
        }
        
        let message6 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "Earn coins by eliminating eggs."
            }, fadeTutorialMessageInAction, SKAction.wait(forDuration: 3), hideArrowAction, fadeTutorialMessageOutAction, SKAction.wait(forDuration: 3), stageFinishedAction])

        let runSequence = SKAction.sequence([fadeTutorialMessageInAction, message1, message2, message3, message4, message5, message6])
        tutorialLabel.mainLabel.run(runSequence)
        
    }
    
    func stage5() {
        self.tutorialLabel.mainLabel.text = "Another wave of eggs are coming!"
        
        let message1 = SKAction.sequence([SKAction.run {
            self.tutorialLabel.mainLabel.text = "Another wave of eggs are coming!"},
                SKAction.wait(forDuration: 3), fadeTutorialMessageOutAction])
        
        let startFinalWave = SKAction.run {
            self.listOfEggTypes = ["BasicEgg", "RollingEgg", "BasicEgg"];
            self.maxEggs = 10;
            self.eggSpawnInterval = 1.5
            self.tutorialStart = true
            self.eggCount = 0
        }
        
        let run = SKAction.sequence([fadeTutorialMessageInAction, message1, startFinalWave])
        tutorialLabel.mainLabel.run(run)
    }
    
    //Default function called when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        checkTappedEgg(touchLocation: touchLocation)
        //checkTappedWeapon(touchLocation: touchLocation)
        touched = true
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
        secretSkipTimeCounter = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //Update function is called every frame. 60times per second
    override func update(_ currentTime: TimeInterval) {
        //print(eggCount)
        //print("TUTORIAL")
        checkWin()
        updateLabels()
        fenceSprite.update()
        moveAndCheckEgg()
        player.update()
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        spawnUpdateTime += currentTime - lastUpdateTime
        if spawnUpdateTime >= eggSpawnInterval && tutorialStart && maxEggs > 0 {
            addEgg()
            maxEggs -= 1
            spawnUpdateTime = 0
        }
        
        if touched {
            secretSkipTimeCounter += currentTime - lastUpdateTime
            print(secretSkipTimeCounter)
            if secretSkipTimeCounter > 3 {
                sound.stopMusic();
                //print("hey")
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                let reveal = SKTransition.fade(withDuration: 1.5)
                view!.presentScene(gameScene!, transition: reveal)
            }
        }
        self.lastUpdateTime = currentTime
    }
    
    /*
     Referenced functions from above below
     */
    
    override func checkTappedEgg(touchLocation: CGPoint) {
        //Checks if an egg has been tapped
        if player.currentTapCount > 0 && player.canTap && tutorialStart {
            player.tapped()
            for egg in eggArray {
                if egg.sprite.contains(touchLocation) {
                    egg.health -= GameData.playerData.playerDamage
                }
            }
        }
    }

    
    override func checkWin() {
        if maxEggs == 0 && eggCount == 4 && tutorialStart && tutorialStage == 1 {
            tutorialStart = false
            tutorialStage = 2
            stage2()
            //play pass tutorial scene
        } else if nextStageReady && tutorialStage == 2 {
            tutorialStart = false
            tutorialStage = 3
            nextStageReady = false
            stage3()
        } else if nextStageReady && tutorialStage == 3 {
            nextStageReady = false
            tutorialStage = 4
            stage5()
        } else if maxEggs == 0 && eggCount == 10 && tutorialStart && tutorialStage == 4 {
            sound.stopMusic()
            print("4444")
            let gameScene = GameScene(fileNamed: "GameScene")
            GameData.playerData.coins = 0
            gameScene?.scaleMode = .aspectFill
            let reveal = SKTransition.fade(withDuration: 1.5)
            view!.presentScene(gameScene!, transition: reveal)
        }
    }
    
    override func updateLabels() {
        //tapCountLabel.text = "Ammo: \(player.currentTapCount)/\(player.maxTapCount)"
        //timerLabel.text = "\(gameTimer)s"
        fenceHealthLabel.text = "\(fenceSprite.health)"
        coinsLabel.text = "\(GameData.playerData.coins)"
        
        
        if !tutorialLabel.mainLabel.isHidden {
            //updates the shadowtext of the tutorial label
            tutorialLabel.secondaryLabel.text = tutorialLabel.mainLabel.text
        }
        if !tutorialLabel2.mainLabel.isHidden {
            //updates the shadowtext of the tutorial label
            tutorialLabel2.secondaryLabel.text = tutorialLabel2.mainLabel.text
        }
        
    }
    
    override func moveAndCheckEgg() {
        for (index, egg) in eggArray.enumerated() {
            if egg.health > 0.0 {
                egg.move()
                egg.checkCrackedRunAnimate()
                egg.checkCrackedKickAnimate(fenceSprite: fenceSprite)
                egg.checkShowHealthBar()
            } else {
                if egg.animationState != "death" {
                    
                }
                egg.checkDeathAnimate(index: index)
            }
        }
    }
    
    override func drawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(GameData.sceneScaling.playableArea)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 8
        addChild(shape)
        //print("shape pos: \(shape.position)")
    }
    
    override func scaleScene() {
        //Scales the scene to fit any iPhone. Causes some distortion horizontally
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
    override func initNodes() {
        
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.mainLayer = mainLayerNode
        
        
        
        guard let secondaryLayerNode = mainLayer.childNode(withName: "secondaryLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.secondaryLayer = secondaryLayerNode
        
        guard let tutorialLayerNode = mainLayer.childNode(withName: "tutorialLayer") else {
            fatalError("Label Nodes not loaded")
        }
        self.tutorialLayer = tutorialLayerNode
        
        guard let fingerNode = tutorialLayer.childNode(withName: "tutorialFinger") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fingerTap = fingerNode
        
        guard let arrowNode = tutorialLayer.childNode(withName: "arrow") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.arrow = arrowNode
        
        arrow.isHidden = true
        arrow.alpha = 0
        
        
//        guard let tapCountLabelNode = secondaryLayer.childNode(withName: "tapCountLabel") as? SKLabelNode else {
//            fatalError("tapCOuntLabel Nodes not loaded")
//        }
//        self.tapCountLabel = tapCountLabelNode
        
        guard let fenceSpriteNode = mainLayer.childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceSprite = Fence(sprite: fenceSpriteNode)
        self.fenceSprite.health = 100
        
        
        guard let fenceLabelNode = secondaryLayer.childNode(withName: "fenceHealthLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.fenceHealthLabel = fenceLabelNode
        
        guard let coinsLabelNode = secondaryLayer.childNode(withName: "coinsLabel") as? SKLabelNode else {
            fatalError("coinsLabelNode Nodes not loaded")
        }
        self.coinsLabel = coinsLabelNode
        
        self.fenceHealthLabel.isHidden = true
        self.coinsLabel.isHidden = true
        
        
//        guard let weaponSpriteNode = secondaryLayer.childNode(withName: "weaponSprite") as? SKSpriteNode else {
//            fatalError("Label Nodes not loaded")
//        }
//        self.weaponSprite = weaponSpriteNode
        
        tutorialLabel = LabelSet(children: tutorialLayer.children, name: "tutorialMessage1")
        tutorialLabel2 = LabelSet(children: tutorialLayer.children, name: "tutorialMessage2")
        tutorialLabel.mainLabel.alpha = 0
        tutorialLabel2.mainLabel.alpha = 0

    }
    
    override func initObjects() {
        player = Player()
        addChild(player.tapBar.barBorder)
    }
    
}

