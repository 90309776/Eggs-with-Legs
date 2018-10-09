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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var maxEggs = 50
    var keepRunning = true
    var eggCount = 0
    
    var eggArray: [Egg] = []
    
    //var eggTypeBasic: [String]
    var basicEggAssets: [[SKTexture]] = [[]]
    var listOfEggTypes: [[SKTexture]] = [[]]
    
    var eggCountLabel: SKLabelNode!
    var fenceSprite: Fence!

    private var lastUpdateTime : TimeInterval = 0
    
    struct PhysicsCategory {
        static let none       : UInt32 = 0
        static let all        : UInt32 = 10
        static let egg        : UInt32 = 1      // 1
        static let fence      : UInt32 = 2      // 2
    }
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        physicsWorld.contactDelegate = self
        
        listOfEggTypes = [[SKTexture(imageNamed: "egg_1"), SKTexture(imageNamed:"egg_2")]]
        guard let labelNode = childNode(withName: "eggCountLabel") as? SKLabelNode else {
            fatalError("Label Nodes not loaded")
        }
        self.eggCountLabel = labelNode
        
        guard let spriteNode = childNode(withName: "fenceSprite") as? SKSpriteNode else {
            fatalError("Label Nodes not loaded")
        }
        
        fenceSprite = Fence(sprite: spriteNode)
        
        if keepRunning {
            run(SKAction.repeat(SKAction.sequence([SKAction.run(addEgg), SKAction.wait(forDuration: 1.0)]), count: maxEggs))
        }
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEgg() {
        let ranNum = Int.random(in: 0 ..< listOfEggTypes.count)
        let eggTextures = listOfEggTypes[ranNum]
        let egg = BasicEgg(sprite: SKSpriteNode(imageNamed: "BE_RA_0"))
        egg.sprite.name = "basicEgg"
        
//      let eggAnimation = SKAction.animate(with: eggTextures, timePerFrame: 0.1)
//      run(SKAction.repeatForever(eggAnimation))
        
        eggCount += 1
        
        let actualY = random(min: 0 - size.height / 2 + egg.sprite.size.height, max: 300)
        //let actualY = CGFloat(0)
        egg.sprite.position = CGPoint(x: (0 - size.width), y: actualY)
        addChild(egg.sprite)
        eggArray.append(egg)
        
        
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let objectA = contact.bodyA.node as! SKSpriteNode
        let objectB = contact.bodyB.node as! SKSpriteNode
        
        print("bodyA: \(String(describing: objectA.name))")
        print("bodyB: \(String(describing: objectB.name))")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        //Checks if an egg has been tapped
        for egg in eggArray {
            if egg.sprite.contains(touchLocation) {
                egg.health = 0
                egg.animationCount = 0
                //egg.sprite.removeFromParent()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        print("\(touchLocation)")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        eggCountLabel.text = "Egg Count: \(eggCount)"
        
        for egg in eggArray {
            egg.animationCount += 1
            if egg.health > 0 {
                egg.move()
                egg.animate()
            } else {
                egg.deathAnimation()
            }
            if egg.sprite.position.x > size.width {
                egg.sprite.removeFromParent()
            }
        }
        //print(eggArray[0].sprite.position)
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }

        self.lastUpdateTime = currentTime
    }
}
