//
//  result.swift
//  FitnessApp
//
//  Created by Jonathan Ly on 8/20/17.
//  Copyright © 2017 Jonathan Ly. All rights reserved.
//

import UIKit
import os.log

class Result: NSObject, NSCoding {
    
    //MARK: Properties
    
    var steps: Double
    var avgPace: Double
    var time: Double
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Results")
    
    
    //MARK: Types
    struct PropertyKey {
        static let steps = "steps"
        static let avgPace = "avgPace"
        static let time = "time"
    }
    
    //MARK: Initialization
    
    init?(steps: Double, avgPace: Double, time: Double) {
        
       
        
        // Initialize stored properties.
        self.steps = steps
        self.avgPace = avgPace
        self.time = time
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(steps, forKey: PropertyKey.steps)
        aCoder.encode(avgPace, forKey: PropertyKey.avgPace)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
       // guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
      //      os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
     //       return nil
    //    }
        
        // Because photo is an optional property of Meal, just use conditional cast.
       
        let steps = aDecoder.decodeDouble(forKey: PropertyKey.steps)

        let avgPace = aDecoder.decodeDouble(forKey: PropertyKey.avgPace)
        
        let time = aDecoder.decodeDouble(forKey: PropertyKey.time)
        
        // Must call designated initializer.
        self.init(steps: steps, avgPace: avgPace, time: time)
        
    }
}

