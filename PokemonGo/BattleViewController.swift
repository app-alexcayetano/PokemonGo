//
//  BattleViewController.swift
//  PokemonGo
//
//  Created by alex on 4/28/17.
//  Copyright © 2017 Alexander Cayetano Yaya. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {

    var pokemon : Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BattleScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        self.view = SKView()
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.scaleMode = .aspectFill
        scene.pokemon = self.pokemon

        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToMapViewController), name: NSNotification.Name("closeBattle"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func returnToMapViewController(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
