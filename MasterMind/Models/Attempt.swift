//
//  Attempt.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Attempt: NSObject {
    var code: [Int8]
    var feedback1: Feedback
    var feedback2: Feedback
    var player: Player
    
    init(code: [Int8], feedback1: Feedback, feedback2: Feedback, player: Player) {
        self.code = code
        self.feedback1 = feedback1
        self.feedback2 = feedback2
        self.player = player
    }
    
    func getCode() -> [Int8] {
        return code
    }
    
    func getFeedback1() -> Feedback {
        return feedback1
    }
    
    func getFeedback2() -> Feedback {
        return feedback2
    }
    
    func getPlayer() -> Player {
        return player
    }
}
