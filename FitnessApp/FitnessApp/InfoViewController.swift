//
//  AboutViewController.swift
//  FitnessApp
//
//  Created by Jonathan Ly on 8/22/17.
//  Copyright © 2017 Jonathan Ly. All rights reserved.
//

import UIKit
class InfoViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   // erases all saved record
    @IBAction func resetRecord(_ sender: UIButton) {
        let tempString: String = ""
        writeFile(tempString: tempString)
        
    }
    // sets dummy data for sample data
    @IBAction func recordDummyData(_ sender: UIButton) {
        let tempString: String = "\n2000\t2.0\t1800\n1000\t6.0\t300\n8000\t8.0\t900"
        writeFile(tempString: tempString)
    }
    
    let fileName = "output.txt"
    var filePath = ""

    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    // used to set dummy data and wipe data
    func writeFile(tempString: String)
    {
        
        let text:String = tempString
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        // Read file content. Example in Swift
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
            
            
            do {
                // Write contents to file
                try  text.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
            }
            catch let error as NSError {
                print("An error took place: \(error)")
                
            }
            
            
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
            
            do {
                print("Creating new file \(fileName)")
                
                try  text.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                
            }
            catch let error as NSError {
                print("An error took place: \(error)")
                
            }
        }
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "FitnessApp",
                                     withExtension: "html") {
            if let htmlData = try? Data(contentsOf: url) {
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                webView.load(htmlData, mimeType: "text/html",
                             textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }
}
