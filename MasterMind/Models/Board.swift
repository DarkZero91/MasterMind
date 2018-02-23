//
//  Board.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Board: NSObject {
    var attempts: [Attempt] = []
    
    func getAttempts() -> [Attempt] {
        return attempts
    }
    
    func addAttempt(attempt: Attempt) {
        self.attempts.append(attempt)
    }
}
