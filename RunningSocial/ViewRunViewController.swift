//
//  ViewRunViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/2/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit

class ViewRunViewController: UIViewController {

    @IBOutlet weak var runTitle: UILabel!
    @IBOutlet weak var runDetails: UILabel!
    @IBOutlet weak var runDistance: UILabel!
    @IBOutlet weak var runDifficulty: UILabel!
    
    
    var run = Run()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        runTitle.text = run.title
        runDetails.text = run.details
        runDistance.text = run.distance
        runDifficulty.text = run.difficulty
    }

    
    
}
