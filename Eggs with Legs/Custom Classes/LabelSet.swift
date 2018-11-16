//
//  Label.swift
//  Eggs with Legs
//
//  Created by 90309776 on 11/12/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//
import SpriteKit
import Foundation

class LabelSet {
    
    /*
     This class is good for when you want to have multiple correlating SKLabelNodes
     that are seperate, but want to condense them into a single object.
     
     EXAMPLE:
        2 Labels for this example
            Egg Cracked Total: 10
     
        The Egg Cracked Total is one SKLabelNode and the string 10 is another SKLabelNode.
        A reason for not combining this as it can be easier to manipulate on or the other while maintaining
        the rest of the text.
     
        With this object you would be able to create these 2 instances of the SKLabelNodes that is condensed down
        to one single object.
     
     HOW TO USE:
        Correlating SKLabelNodes must be nested within the parent label (mainLabel) and
        secondary and third labels must be named "secondaryLabel", and "thirdLabel"
            ex: EggCrackedTotalLabel
                    secondaryLabel
     
        EggCrackedTotalLabel is the main referencing label. secondaryLabel is a child label of EggCrackedTotalLabel
     
        After the hierachy is assigned, create the object variable with required parameters.
            ex: var eggCrackedTotalLabel = LabelSet(children: self.children, name: "EggCrackedTotalLabel")
     
        children is the array of SKNodes from the parent of the mainLabel. In this case,
        the parent of EggCrackedTotalLabel which would just be the main scene's so just use self.children.
        If the parent label were to rest inside a different node, then use that node's children.
     
    */
    
    var mainLabel: SKLabelNode!
    var secondaryLabel: SKLabelNode!
    var thirdLabel: SKLabelNode!
    
    var nodeChildren: [SKNode]
    
    init(children: [SKNode], name: String) {
        self.nodeChildren = children
        
        for node in nodeChildren {
            if node.name == name {
                mainLabel = node as? SKLabelNode
                for childNode in node.children {
                    if childNode.name == "secondaryLabel" {
                        self.secondaryLabel = childNode as? SKLabelNode
                    } else if childNode.name == "thirdLabel" {
                        self.thirdLabel = childNode as? SKLabelNode
                    }
                }
            }
        }
    }
}
