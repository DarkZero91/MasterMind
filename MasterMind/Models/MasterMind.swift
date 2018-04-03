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
	var userStarts: Bool
	var start: Bool

	init(avgGuess: Double) {
		player1 = AI(name: "Dirty Dan", avgGuess: avgGuess)
        player2 = Player(name: "hooman", code: [])
		let userStarts = arc4random_uniform(2) == 0
		if(userStarts){
        	player_turn = player2
		} else {
			player_turn = player1
		}
		self.userStarts = userStarts
		self.start = true
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
    func switchTurn() {
        if(player_turn == player1) {
            player_turn = player2
        } else {
            player_turn = player1
        }
		start = false
    }
	
	//---------------------------- API END
	
	func simulateAITurn() -> [Int]{
		let code = player1.chooseAttempt(attempts: attempts)
		return code
	}
	
	func randomBool() -> Bool {
		return arc4random_uniform(2) == 0
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
