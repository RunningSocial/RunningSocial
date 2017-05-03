//
//  RunListViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/1/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit
import Firebase

class RunListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var runs : [Run] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        
        FIRDatabase.database().reference().child("runs").observe(FIRDataEventType.childAdded, with: {(snapshot) in

            let run = Run()
            run.date = (snapshot.value as! NSDictionary)["date"] as! String
            run.owner = (snapshot.value as! NSDictionary)["owner"] as! String
            run.title = (snapshot.value as! NSDictionary)["title"] as! String
            run.details = (snapshot.value as! NSDictionary)["details"] as! String
            run.distance = (snapshot.value as! NSDictionary)["distance"] as! String
            run.difficulty = (snapshot.value as! NSDictionary)["difficulty"] as! String
            
            if run.title != "" {
                self.runs.append(run)
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let run = runs[indexPath.row]
        cell.textLabel?.text = run.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let run = runs[indexPath.row]
        performSegue(withIdentifier: "viewrunsegue", sender: run)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewrunsegue" {
            let nextVC = segue.destination as! ViewRunViewController
            nextVC.run = sender as! Run
        }
    }
    
    // LOGOUT FUNCTION
    @IBAction func logoutTapped(_ sender: Any) {
        print("Sign out initiated")
        dismiss(animated: true, completion: nil)
    }
}
