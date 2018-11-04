//
//  ShopButton.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/3/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class ShopButton {
    
    var spriteButton: SKSpriteNode!
    var descLabel: SKLabelNode!
    var secondaryLabel: SKLabelNode!
    var costLabel: SKLabelNode!
    var itemCost: Int!
    
    
    var winSceneChildrenNodes: [SKNode]
    
    init(children: [SKNode], name: String) {
        self.winSceneChildrenNodes = children
        self.itemCost = 0
        
        for node in winSceneChildrenNodes {
            if node.name == name {
                spriteButton = node as? SKSpriteNode
                for childNode in node.children {
                    if childNode.name == "descLabel" {
                        self.descLabel = childNode as? SKLabelNode
                    }
                    if childNode.name == "secondaryLabel" {
                        self.secondaryLabel = childNode as? SKLabelNode
                    }
                    if childNode.name == "costLabel" {
                        self.costLabel = childNode as? SKLabelNode
                    }
                }
            }
        }
    }
}
