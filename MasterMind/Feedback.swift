//
//  Feedback.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Feedback: NSObject {
    var hits: Int8 = 0
    var misaligned: Int8 = 0
    
    func getHits() -> Int8 {
        return hits
    }
    
    func getMisaligned() -> Int8 {
        return misaligned
    }
}
