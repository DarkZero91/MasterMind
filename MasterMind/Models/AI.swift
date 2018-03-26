//
//  AI.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import Foundation

class AI: Player {
	
	let brains = GeneticAlgorithm()
	var skillLevel:Double
	
	init(name:String, code:[Int], skillLevel:Double) {
		self.skillLevel = skillLevel
		super.init(name:name, code:code)
	}
	
	func chooseAttempt(attempts:[Attempt]) -> [Int] {
		let chosenCode = brains.chooseAttempt(attempts: attempts, ownCode: code, skillLevel: skillLevel)
		return chosenCode
	}
	
	func initializePossibilityList() -> [[Int]] {
		//generate all possible colorcodes, assume 4 positions and 6 different colors
		var all_combinations = [[Int]]()
		for x1 in 1...6 {
			for x2 in 1...6 {
				for x3 in 1...6 {
					for x4 in 1...6 {
						all_combinations.append([x1,x2,x3,x4])
					}
				}
			}
		}
		return all_combinations
	}
}
