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
    var code:[Character]
    var score:Int8 = 0
    
    init(name:String, code:[Character]) {
        self.name = name
        self.code = code
    }
    
    func getname() -> String {
        return name
    }

    func setName(name:String) {
        self.name = name
    }

    func getCode() -> [Character] {
        return code
    }

    func setCode(code:[Character]) {
        self.code = code
    }

    func getScore() -> Int8 {
        return score
    }
    
    func incrementScore() {
        score = score + 1
    }

}
