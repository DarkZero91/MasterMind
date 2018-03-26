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

	override init() {
		// TODO receive info about which player can start, and maybe player names
		player1 = AI(name: "Dirty Dan", code: [1,1,2,1], skillLevel: 4.25)
        player2 = Player(name: "hooman", code: [])
        player_turn = player2
    }

    //---------------------------- API START

    // Submits the players attempt
    func checkCode(choice:[Int]) -> Attempt {
        let attempt = Attempt(choice:choice)
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
			simulateAITurn(controller: controller)
        }
    }
	
	//---------------------------- API END
	
	func simulateAITurn(controller: ViewController){
		let code = player1.chooseAttempt(attempts: attempts)
		for i in 0...3{
			let c = code[i]
			//TODO fill the right button with the color
			let buttonindex = attempts.count*4 + i
			controller.colorButton(index:buttonindex, colorValue:c)
		}
		controller.drawNewAttempt(code: code)
	}
	
	
    func getAttempts() -> [Attempt] {
        return attempts
    }
}
