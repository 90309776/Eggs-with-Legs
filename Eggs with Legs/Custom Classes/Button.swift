//
//  ShopButton.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/3/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

class Button {
    
    /*
     This is the framework for every button.
     A button can include a sprite for testing, and 2 labels for
     descriptive purposes.
     
     Class is designed specifically for uses in a shop for now
    */
    
    //button uses a label set!!!
    
    var spriteButton: SKSpriteNode!
    var descLabel: SKLabelNode!
    var secondaryLabel: SKLabelNode!
    var costLabel: SKLabelNode!
    var itemCost: Int!
    var isButtonEnabled: Bool
    var isTapped: Bool

    var winSceneChildrenNodes: [SKNode]
    
    init(children: [SKNode], name: String) {
        self.winSceneChildrenNodes = children
        self.itemCost = 0
        self.isButtonEnabled = true
        self.isTapped = false
        
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
    
    func hasTouched(touchLocation: CGPoint) -> Bool{
        return self.spriteButton.contains(touchLocation)
    }
    //Idea add another constructor to accept a second sktexture for an on tapping texture and release
}
