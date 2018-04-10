//
//  TableController.swift
//  FitnessApp
//
//  Created by Jonathan Ly on 8/21/17.
//  Copyright © 2017 Jonathan Ly. All rights reserved.
///Attributions- https://www.youtube.com/watch?v=CFtffLlgMNs
///Attributions- https://stackoverflow.com/questions/39567808/value-type-of-any-has-no-member-objectforkey-swift-3-conversion


import UIKit

class ResultTableViewController: UITableViewController {
    
    var dictResult = [String:String]()
    var arrayResult = NSMutableArray()
    
    let fileName = "output.txt"
    var filePath = ""
    
    
    // Find documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    
    func readFile() -> String
    {
        
        var text:String
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return "invalid"
        }
        
        // Read file content. Example in Swift
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
            
            text = (contentFromFile as String)
            return text
            
            
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        return "invaild"
    }
    
    // Loads the data into an array
    func loadResults() {
        
        let text:String = readFile()
        var readings = text.components(separatedBy: "\n") as [String]
        
        let readingCount = readings.count
        
        if readingCount > 1 {
            for i in 1..<readings.count {
                let resultData = readings[i].components(separatedBy: "\t")
                dictResult["Steps"] = "\(resultData[0])"
                dictResult["AveragePace"] = "\(resultData[1])"
                dictResult["Time"] = "\(resultData[2])"
            
                arrayResult.add(dictResult)
            }
        
            

        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayResult.removeAllObjects()
        loadResults()
        tableView.reloadData()
        print("reloading")
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Table View 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResult.count
    }
    
    // Displays data in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell

        
        let result = arrayResult[indexPath.row] as AnyObject
        
        cell.stepsLabel!.text = "Steps:                 \(result["Steps"] as! String) "
        cell.avgPaceLabel!.text = "Average Pace:    \(result["AveragePace"] as! String)"
        cell.timeLabel!.text = "Time:                   \(result["Time"] as! String)"
        return cell

    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Number of Runs: \(arrayResult.count)"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    

    
}
