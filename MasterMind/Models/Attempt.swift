//
//  Attempt.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class Attempt: NSObject {
    var choice: [Character]
    var player1_feedback: (black:Int, white:Int)?
    var player2_feedback: (black:Int, white:Int)?
    
    init(choice:[Character]) {
        self.choice = choice
        self.player1_feedback = nil
        self.player2_feedback = nil
    }
    
    func getChoice() -> [Character] {
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
        var hits = ["o","o","o","o"]
        var code = player.getCode()

        for x in 0...3 {
            if choice[x] == code[x]{
                black += 1
                hits[x] = "x"
            }
        }

        for x in 0...3{
            if hits[x] != "x"{
                if code.contains(choice[x]){
                    white += 1
                }
            }
        }

        return (black, white)
    }
}
