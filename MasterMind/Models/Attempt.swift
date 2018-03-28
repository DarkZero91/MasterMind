//
//  Attempt.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Attempt: NSObject {
    var choice: [Int]
	var player: Player
    var player1_feedback: (black:Int, white:Int)?
    var player2_feedback: (black:Int, white:Int)?
    
	init(choice:[Int], player:Player) {
		print("Choice: \(choice)")
        self.choice = choice
		self.player = player
        self.player1_feedback = nil
        self.player2_feedback = nil
    }
    
    func getChoice() -> [Int] {
        return choice
    }
    
    func getPlayer1Feedback() -> (black:Int, white:Int) {
        return player1_feedback!
    }

    func setPlayer1Feedback(player:Player) {
        player1_feedback = evaluate(player:player)
    }
    
    func getPlayer2Feedback() -> (black:Int, white:Int) {
        return player2_feedback!
    }

    func setPlayer2Feedback(player:Player) {
        player2_feedback = evaluate(player:player)
    }

    func evaluate(player:Player) -> (black:Int, white:Int) {
        var white = 0
        var black = 0
        let code = player.getCode()
		// make sure copies are modified
		var chosen = choice
		var copyCode = code

        for x in 0...3 {
            if chosen[x] == copyCode[x]{
                black += 1
				chosen[x] = 0
				copyCode[x] = 0
            }
        }

        for x in 0...3 {
			if let i = copyCode.index(of: chosen[x]), chosen[x] != 0 {
				white += 1
				copyCode[i] = 0
			}
        }
        return (black, white)
    }
}
