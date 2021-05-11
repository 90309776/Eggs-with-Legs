//
//  BaseScene.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/16/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

//CUSTOM ABSTRACT VIEW CLASS
class BaseScene: SKScene {
    
    //TRACKING LABELS
    var weaponSprite: SKSpriteNode!
    var fenceHealthLabel: SKLabelNode!
    var tapCountLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var mainLayer: SKNode!
    var secondaryLayer: SKNode!
    
    var eggArray: [Egg]!
    var eggArrayNodes: [SKSpriteNode]!
    var towerArray: [Tower]!
    var projectileArray: [Projectile]!
    var listOfEggTypes: [String]!
    
    
    //CUSTOM INIT
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        
        
    }
    
    
    
}
