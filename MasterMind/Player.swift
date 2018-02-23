//
//  Player.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Player: NSObject {
    var name:String = ""
    var score:Int8 = 0
    
    init(name:String) {
        self.name = name
    }
    
    func getname() -> String {
        return name
    }

    func setName(name: String) {
        self.name = name
    }

    func getScore() -> Int8 {
        return score
    }
    
    func incrementScore() {
        score = score + 1
    }

}
