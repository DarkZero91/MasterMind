//
//  MasterMind.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class MasterMind: NSObject {
    var player1: Player
    var player2: Player
    var player_turn: Player
    var attempts: [Attempt] = []

    override init() {
        player1 = AI(name: "Dirty Dan", code: [1,1,2,1])
        player2 = Player(name: "hooman", code: [])
        player_turn = player1
    }

    //---------------------------- API START

    // Submits the players attempt
    func checkCode(choice:[Int]) -> Attempt {
        let attempt = Attempt(choice:choice)
        attempt.setPlayer1Feedback(player:self.player1)
        attempt.setPlayer2Feedback(player:self.player2)
        attempts.append(attempt)
        switchTurn()
        return attempt
    }

    func getPlayerTurn() -> Player {
        return player_turn
    }

    func getTurn() -> Int {
        return attempts.count + 1
    }

    //---------------------------- API END

    // Switches the turn from one player to another
    func switchTurn() {
        if(player_turn == player1) {
            player_turn = player2
        } else {
            player_turn = player1
        }
    }

    func getAttempts() -> [Attempt] {
        return attempts
    }
}
