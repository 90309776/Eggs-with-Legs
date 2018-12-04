//
//  GameViewController.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/4/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            view.preferredFramesPerSecond = 60
            //setupSceneScaling()
//            if let scene = GameScene(fileNamed: "GameScene") {
//                scene.scaleMode = .aspectFill
//
//                view.presentScene(scene)
//            }
            
            if let scene = LoadingScene(fileNamed: "LoadingScene") {
                scene.scaleMode = .aspectFill

                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            //view.showsPhysics = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    
    func setupSceneScaling() {
        
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
