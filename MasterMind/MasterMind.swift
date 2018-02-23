//
//  MasterMind.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class MasterMind: NSObject {
    var board: Board
    var player1: Player
    var player2: Player
    
    override init() {
        board = Board()
        player1 = AI(name: "Vieze Freddy")
        player2 = Player(name: "hooman")
    }
}
