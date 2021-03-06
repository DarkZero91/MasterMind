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
	
	init(name:String, avgGuess:Double) {
		self.skillLevel = 4 // place holder, cannot be init via func before super.init
		let code = brains.chooseRandomCode()
		print("AI's code: \(code)")
		super.init(name:name, code:code)
		setSkillLevel(averageGuesses: avgGuess) // real init
	}
	
	func unzip<K, V>(_ array: [(key: K, value: V)]) -> ([K], [V]) {
		var keys = [K]()
		var values = [V]()
		
		keys.reserveCapacity(array.count)
		values.reserveCapacity(array.count)
		
		array.forEach { key, value in
			keys.append(key)
			values.append(value)
		}
		
		return (keys, values)
	}
	
	func chooseAttempt(attempts:[Attempt]) -> [Int] {
		//print("In chooseAttempt of AI")
		print("AI skilllevel is \(skillLevel)")
		if(attempts.count > 0 && attempts.last!.getPlayer2Feedback().black==4){
			// opponent has tried its own code: make use of it
			return attempts.last!.choice
		}
		var (codes, infoGainValues, giveAwayValues) = brains.chooseAttempt(attempts: attempts, ownCode: code, skillLevel: skillLevel)
		if(codes.count==1){
			// only one possible code: return it
			return codes[0]
		}
		// make sure previous attempts are removed
		(codes, infoGainValues, giveAwayValues) = filterOutPreviousAttempts(codes: codes, infoGainValues:infoGainValues, giveAwayValues:giveAwayValues, attempts: attempts)
		if(codes.count==1){
			// only one possible code: return it
			return codes[0]
		}
		
		// for now, choose the one with most info gain for AI
		print("Codes: \(codes.count), IG: \(infoGainValues.count), GA: \(giveAwayValues.count)")
		var minInfoGain = 0.0
		if(infoGainValues.count > 0){
			minInfoGain = Double(infoGainValues.min()!) // min value means most info gained
		} else {
			// should never happen (genetic algorithm did not find any code)
			print("Error: No code for info gain has been found.")
			exit(0)
		}
		let indexMin = infoGainValues.index(of:minInfoGain)!
		let chosenCode = codes[indexMin]
		return chosenCode
	}
	
	func filterOutPreviousAttempts(codes:[[Int]], infoGainValues:[Double], giveAwayValues:[Int], attempts:[Attempt]) -> ([[Int]], [Double], [Int]){
		// filter out previous guesses, but make sure not all codes are removed
		var prev = [Bool]()
		for code in codes {
			// identify duplicates
			prev.append(previousGuess(guess: code, attempts: attempts))
		}
		// copy data of non-duplicates
		var newCodes = [[Int]]()
		var newIG = [Double]()
		var newGA = [Int]()
		for i in 0...prev.count-1 {
			if(!prev[i]){
				newCodes.append(codes[i])
				newIG.append(infoGainValues[i])
				newGA.append(giveAwayValues[i])
			}
		}
		if(newCodes.isEmpty){
			// make sure at least one is kept (random)
			let i = Int(arc4random_uniform(UInt32(codes.count)))
			newCodes.append(codes[i])
			newIG.append(infoGainValues[i])
			newGA.append(giveAwayValues[i])
		}
		return (newCodes, newIG, newGA)
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
	
	func previousGuess(guess:[Int], attempts:[Attempt]) -> Bool {
		for att in attempts {
			if att.choice == guess {
				return true
			}
		}
		return false
	}
	
	func setSkillLevel(averageGuesses:Double){
		let newlevel = max(4.0, 0.8370674 - (-1.741997/0.4705081)*(1-pow(M_E, -0.4705081*averageGuesses)))
		skillLevel = newlevel
		//print("Skill level of AI set to \(skillLevel)")
	}
}
