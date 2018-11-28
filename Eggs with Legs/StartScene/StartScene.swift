//
//  StartScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/16/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import GameplayKit
import Foundation

class StartScene: SKScene {
    
    var mainLayer: SKNode!
    var menuLayer: SKNode!
    var settingsLayer: SKNode!
    
    var playButton: Button!
    var settingsButton: Button!
    var vibrationButton: Button!
    
    var highScoreLabel: SKLabelNode!
    var eggCrackedLabel: SKLabelNode!
    
    override func sceneDidLoad() {
        initNodes()
        initObjects()
        //makeButtons()
        scaleScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        //If pressed, goes to tutorialScene

        pressedPlayButton(touchLocation: touchLocation)
        pressedSettingsButton(touchLocation: touchLocation)
        if !settingsLayer.isHidden {
            pressedVibrationButton(touchLocation: touchLocation)
        }
    }

    /*
     REFERENCED FUNCTIONS ARE BELOW
    */
    
    var backgroundSprite: SKSpriteNode!
    
    func initNodes() {
        guard let mainLayerNode = childNode(withName: "mainLayer") else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.mainLayer = mainLayerNode
        
        guard let menuLayerNode = mainLayer.childNode(withName: "menuLayer") else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.menuLayer = menuLayerNode
        
        guard let settingsLayerNode = mainLayer.childNode(withName: "settingsLayer") else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.settingsLayer = settingsLayerNode
        
        guard let backgroundNode = mainLayer.childNode(withName: "background") as? SKSpriteNode else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.backgroundSprite = backgroundNode

        settingsLayer.alpha = 1
        settingsLayer.isHidden = true
        
        guard let highscoreNode = mainLayer.childNode(withName: "highscore") as? SKLabelNode else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.highScoreLabel = highscoreNode
        GameData.levelData.highscore = UserDefaults.standard.value(forKey: "highScore") as! Int
        self.highScoreLabel.text = "Highscore: \(GameData.levelData.highscore!)"
        print(GameData.levelData.highscore!)
        print(UserDefaults.standard.value(forKey: "highscore"))
        
        guard let eggsCrackedNode = mainLayer.childNode(withName: "eggsCracked") as? SKLabelNode else {
            fatalError("mainlayer failed to load. Maybe not in childNode list?")
        }
        self.eggCrackedLabel = eggsCrackedNode
        let eggCount = UserDefaults.standard.value(forKey: "eggscracked") as! Int
        eggCrackedLabel.text = "Eggs Cracked: \(eggCount)"
        
    }
    
    func initObjects() {
        playButton = Button(children: menuLayer.children, name: "playButton")
        settingsButton = Button(children: menuLayer.children, name: "settingsButton")
        vibrationButton = Button(children: settingsLayer.children, name: "vibrationButton")
        if !GameData.settingsData.vibration {
            vibrationButton.spriteButton.texture = SKTexture(imageNamed: "switch_off")
        }
    }
    
    func pressedPlayButton(touchLocation: CGPoint) {
        let reveal = SKTransition.fade(withDuration: 3)
        
        if playButton.hasTouched(touchLocation: touchLocation) {
            if GameData.settingsData.hasPlayedTutorial {
                let tutorialScene = GameScene(fileNamed: "GameScene")
                tutorialScene?.scaleMode = .aspectFill
                view!.presentScene(tutorialScene!, transition: reveal)
            } else {
                let tutorialScene = TutorialLevel1(fileNamed: "TutorialLevel1")
                GameData.settingsData.hasPlayedTutorial = true
                tutorialScene?.scaleMode = .aspectFill
                view!.presentScene(tutorialScene!, transition: reveal)
            }
        }
    }
    
    func pressedSettingsButton(touchLocation: CGPoint) {
        if settingsButton.hasTouched(touchLocation: touchLocation) {
            settingsLayer.isHidden = !settingsLayer.isHidden
        }
    }
    
    func pressedVibrationButton(touchLocation: CGPoint) {
        if vibrationButton.hasTouched(touchLocation: touchLocation) {
            if vibrationButton.isTapped {
                vibrationButton.spriteButton.texture = SKTexture(imageNamed: "switch_off")
                GameData.settingsData.vibration = false
                vibrationButton.isTapped = !vibrationButton.isTapped
            } else {
                vibrationButton.spriteButton.texture = SKTexture(imageNamed: "switch_on")
                GameData.settingsData.vibration = true
                vibrationButton.isTapped = !vibrationButton.isTapped
            }
        }
    }
    
    func makeButtons() {
        var playSpriteButton = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 450, height: 130))
        playSpriteButton.position = CGPoint(x: GameData.sceneScaling.playableAreaOrigin.x + 540, y: GameData.sceneScaling.playableAreaOrigin.y + 720)
        
        
        var playSpriteText = SKLabelNode(text: "Play")
        playSpriteButton.addChild(playSpriteText)
        playSpriteText.position = CGPoint(x: -10, y: -10)
        playSpriteText.name = "descLabel"
        
        addChild(playSpriteButton)
        
    }
    
    
    //Sets the scene's mainlayer to scale to the device's playable area
    func scaleScene() {
        mainLayer.yScale = GameData.sceneScaling.sceneYScale
        mainLayer.position.y = GameData.sceneScaling.playableAreaOrigin.y
    }
    
}
