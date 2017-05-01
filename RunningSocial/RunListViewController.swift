//
//  RunListViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/1/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit

class RunListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logoutTapped(_ sender: Any) {
        print("Sign out initiated")
        dismiss(animated: true, completion: nil)
    }
}
