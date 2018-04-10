//
//  ViewController.swift
//  FitnessApp
//
//  Created by Jonathan Ly on 8/12/17.
//  Copyright © 2017 Jonathan Ly. All rights reserved.
//
//
///Attributions- https://medium.com/@tstenerson/lets-make-a-line-chart-in-swift-3-5e819e6c1a00
///Attributions- https://wwwbruegge.in.tum.de/lehrstuhl_1/home/98-teaching/tutorials/505-sgd-ws13-tutorial-core-motion
///Attributions- https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
///Attributions- https://stackoverflow.com/questions/39524148/requires-a-development-team-select-a-development-team-in-the-project-editor-cod
///Attributions- http://swiftdeveloperblog.com/code-examples/read-and-write-string-into-a-text-file/
///Attributions- http://www.clker.com/clipart-9978.html
///Attributions- http://www.clker.com/clipart-10550.html

import UIKit
import CoreMotion


class PedometerController: UIViewController {
    
    
    // Color for the start and stop button
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

    // Values for the pedometer data
    var steps:Int! = nil
    var pace:Double! = nil
    var avgPace:Double! = nil
    var distance:Double! = nil
    
    // popup view results for run
    var resultsView: UIView!
    
    var pedometer = CMPedometer()
    
    
    // timers
    var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    
    // results
    var resultsArray = [Double]()
    
    // write file
    let file = "pedometerResults.txt"
    
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    
    
    @IBAction func startStopButton(_ sender: UIButton) {
        if sender.tag == 1 {
            //Start the pedometer
            pedometer = CMPedometer()
            startTimer()
            pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                if let pedData = pedometerData{
                    self.steps = Int(pedData.numberOfSteps)
                    //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                    if let distance = pedData.distance{
                        self.distance = Double(distance)
                    }
                    if let averageActivePace = pedData.averageActivePace {
                        self.avgPace = Double(averageActivePace)
                    }
                    if let currentPace = pedData.currentPace {
                        self.pace = Double(currentPace)
                    }
                } else {
                    self.steps = nil
                }
            })
            //Toggle the UI to on state
            statusTitle.text = "Pedometer On"
            sender.setImage(#imageLiteral(resourceName: "stop_icon"), for: . normal)
            sender.tag = 0
            
        } else {
            
            avgPace = computedAvgPace()
            // Record Results
            if self.steps == nil { self.steps = 0}
            resultsArray.append(Double(steps))
            resultsArray.append(avgPace)
            resultsArray.append(timeElapsed)
            writeFile(array: resultsArray)
            // Shows exericise results
            showResults()
            //Stop the pedometer
            pedometer.stopUpdates()
            stopTimer()
            //Toggle the UI to off state
            statusTitle.text = "Pedometer Off"
            sender.setImage(#imageLiteral(resourceName: "start_icon"), for: .normal)
            
            sender.tag = 1
            resetPedometer()
            resultsArray.removeAll()
            
            
            
        }
    }
    //MARK: - timer functions
    func startTimer(){
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
        displayPedometerData()
    }
    
    func timerAction(timer:Timer){
        displayPedometerData()
    }
    // display the updated data
    func displayPedometerData(){
        timeElapsed += 1.0
        statusTitle.text = "On: " + timeIntervalFormat(interval: timeElapsed)
        //Number of steps
        if let steps = self.steps{
            
            stepsLabel.text = String(format:"Steps: %i",steps)
        }
        
        // distance
        if let distance = self.distance{
            distanceLabel.text = String(format:"Distance: %02.02f meters,\n %02.02f mi",distance,miles(meters: distance))
        } else {
            distanceLabel.text = "Distance: N/A"
        }
        
        // average pace
        if let averagePace = self.avgPace{
            avgPaceLabel.text = paceString(title: "Average Pace", pace: averagePace)
        } else {
            avgPaceLabel.text =  paceString(title: "Average Pace", pace: computedAvgPace())
        }
        
        // pace
        if let pace = self.pace {
            print(pace)
            paceLabel.text = paceString(title: "Pace:", pace: pace)
        } else {
            paceLabel.text = "Pace: N/A "
            paceLabel.text =  paceString(title: "Pace", pace: computedAvgPace())
        }
    }
    
    //MARK: - Display and time format functions
    
    // convert seconds to hh:mm:ss as a string
    func timeIntervalFormat(interval:TimeInterval)-> String{
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    // convert a pace in meters per second to a string with
    // the metric m/s and the Imperial minutes per mile
    func paceString(title:String,pace:Double) -> String{
        var minPerMile = 0.0
        let factor = 26.8224 //conversion factor
        if pace != 0 {
            minPerMile = factor / pace
        }
        let minutes = Int(minPerMile)
        let seconds = Int(minPerMile * 60) % 60
        return String(format: "%@: %02.2f m/s \n\t\t %02i:%02i min/mi",title,pace,minutes,seconds)
    }
    
    func computedAvgPace()-> Double {
        if let distance = self.distance{
            pace = distance / timeElapsed
            return pace
        } else {
            return 0.0
        }
    }
    
    func miles(meters:Double)-> Double{
        let mile = 0.000621371192
        return meters * mile
    }
    

    func showResults() {
        
        // create the alert
        let alert = UIAlertController(title: "Results", message: "Good Workout!\n Here are your results\n Run Time: \(timeElapsed+1) seconds \n Steps: \(resultsArray[0])\n Average Pace: \(resultsArray[1]) mph\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetPedometer(){
        steps = nil
        pace = nil
        avgPace = nil
        distance = nil
        timeElapsed = 0
        
    }
    
    let fileName = "output.txt"
    var filePath = ""
    
    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    

    func writeFile(array: [Double])
    {

        var text:String
        
        text = "\n" + String(format:"%.0f",array[0])  + "\t"  + String(format:"%.1f",array[1]) + "\t" + String(format:"%.0f",array[2])
        
       
        
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
            
            text = (contentFromFile as String) + text
            
            
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
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

