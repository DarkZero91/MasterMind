//
//  MasterMind.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation
import UIKit

class MasterMind: NSObject {
    var player1: AI
    var player2: Player
    var player_turn: Player
    var attempts: [Attempt] = []

	init(avgGuess: Double) {
		// TODO receive info about which player can start, and maybe player names
		player1 = AI(name: "Dirty Dan", avgGuess: 4.25)
        player2 = Player(name: "hooman", code: [])
        player_turn = player2
    }

    //---------------------------- API START

    // Submits the players attempt
    func checkCode(choice:[Int]) -> Attempt {
		let attempt = Attempt(choice:choice, player:player_turn)
        attempt.setPlayer1Feedback(player:self.player1)
        attempt.setPlayer2Feedback(player:self.player2)
        attempts.append(attempt)
		print("Code \(choice) checked")
        return attempt
    }

    func getPlayerTurn() -> Player {
        return player_turn
    }

    func getTurn() -> Int {
        return attempts.count + 1
    }

    // Switches the turn from one player to another
    func switchTurn(controller: ViewController) {
        if(player_turn == player1) {
            player_turn = player2
        } else {
            player_turn = player1
        }
    }
	
	//---------------------------- API END
	
	func simulateAITurn() -> [Int]{
		let code = player1.chooseAttempt(attempts: attempts)
		return code
	}
	
	
    func getAttempts() -> [Attempt] {
        return attempts
    }
	
	func getPlayer1() -> Player{
		return player1
	}
	func getPlayer2() -> Player{
		return player2
	}
}
