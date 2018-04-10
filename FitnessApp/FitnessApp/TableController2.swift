//
//  TableController.swift
//  FitnessApp
//
//  Created by Jeffrey Ly on 8/21/17.
//  Copyright © 2017 Jonathan Ly. All rights reserved.
//


import UIKit

class TableController2: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        var index = 0
        while index < 10 {
            tableView(<#T##tableView: UITableView##UITableView#>, cellForRowAt: <#T##IndexPath#>)
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    

 
    
    // Creates the list of avialbe searches by listing URL and the content.
    func tableView( tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        
        cell.stepsLabel!.text = "5"
        cell.avgPaceLabel!.text = "10"
        cell.timeLabel!.text = "20"
        return cell
    }

    
    
}


