//
//  Clue.swift
//  MasterMind
//
//  Created by R. Elderman on 06/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//
import Foundation
import Darwin


class Clue: NSObject {
	
	var colorCode:[Int]
	var whitePoints:Int
	var blackPoints:Int
	var myWhitePoints:Int
	var myBlackPoints:Int
	
	
	init(colorCode:[Int], whitePoints:Int, blackPoints:Int, myWhitePoints:Int, myBlackPoints:Int) {
		self.colorCode = colorCode
		self.whitePoints = whitePoints
		self.blackPoints = blackPoints
		self.myBlackPoints = myBlackPoints
		self.myWhitePoints = myWhitePoints
	}
	
	func getColorCode() -> [Int] {
		return colorCode
	}
	
	func getWhitePoints() -> Int {
		return whitePoints
	}
	
	func getBlackPoints() -> Int {
		return blackPoints
	}
	
	func getMyWhitePoints() -> Int {
		return myWhitePoints
	}
	
	func getMyBlackPoints() -> Int {
		return myBlackPoints
	}
}


extension Array  {
    func random() -> Element  {
        return self[Int(arc4random_uniform(UInt32(self.count)))]  
    }
}

//################################# GENERAL FUNCTIONS ###################################
func chooseRandomCodeFromList(possibilities:[Int]) -> Int {
    return possibilities.random()
}

func chooseRandomCode() -> [Int] {
    var att = [Int]()
    for _ in 0...3 {
        //append random value between 1 and 6
        att.append(Int(arc4random_uniform(6)) + 1)
    }
    return att
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

func generateClue(att:[Int], colorCode:[Int], ownColorCode:[Int]?) -> Clue {
    var attempt = att // make sure copy is modified (this might be enough in swift?)
    var code = colorCode // idem
    var wp = 0
    var bp = 0
    var mywp = 0
    var mybp = 0
	var myattempt = [Int]()
	var ownCode = [Int]()
    if(ownColorCode != nil){
        myattempt = att
		ownCode = ownColorCode! // save: just checked
    }
    for x in 0...attempt.count-1{
        if attempt[x] == code[x]{
            bp += 1
            attempt[x] = 0
            code[x] = 0
        }
        if(ownColorCode != nil){
            if myattempt[x] == ownCode[x]{
                mybp += 1
                myattempt[x] = 0
                ownCode[x] = 0
            }
        }
    }
        
    if(bp != 4){
        for x in 0...attempt.count-1{
			if let i = code.index(of: attempt[x]), attempt[x] != 0 {
                wp += 1
				code[i] = 0
            }
        }
    }

    if(ownColorCode != nil && mybp != 4){
        for x in 0...attempt.count-1{
			if let i = ownCode.index(of: myattempt[x]), myattempt[x] != 0 {
                mywp += 1
				ownCode[i] = 0
            }
        }
    }
	return Clue(colorCode: att, whitePoints: wp, blackPoints: bp, myWhitePoints: mywp, myBlackPoints: mybp)
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
//################################## GENETIC ALGORITHM #####################################

//# generate a new population with "size" random codes
func generateNewPopulation(size:Int) -> [[Int]] {
    var population = [[Int]]()
    while(population.count<size){
        var code = chooseRandomCode()
		while(population.map{$0 == code}.contains(true)){ //# 2d array contains 1d array not implemented: this works too ;)
            code = chooseRandomCode()
        }
        population.append(code)
    }
    return population
}

//# select a code to act as a parent, using chances for each code and a randomly selected value between 0 and 1
func selectParent(chances:[Double], value:Double) -> Int {
    var tot = 0.0
	var out = 0
    for x in 0...chances.count-1{
        tot += chances[x]
        //# if total value becomes bigger than randomly selected number, return index 
        if(tot >= value){
            out = x
			break
        }
    }
	return out
}

//# apply cross over between two parents
func applyCrossOver(population:[[Int]], selectionChances:[Double], onePointCrossOverChance:Double) -> [Int]{
    //# select two parents
	let parOne = population[selectParent(chances:selectionChances, value:drand48())]
	let parTwo = population[selectParent(chances:selectionChances, value:drand48())]
    if(drand48() <= onePointCrossOverChance){ //# apply one-point crossover
        let crossPoint = Int(arc4random_uniform(2)) + 1 // 1 or 2
		let newCode = Array(parOne.prefix(crossPoint)) + Array(parTwo.suffix(parTwo.count-crossPoint))
        return newCode
    } else { //# apply two-point crossover
        let crossPointOne = Int(arc4random_uniform(2)) + 1 // 1 or 2
		var crossPointTwo = 2
        if(crossPointOne == 1){
            crossPointTwo = Int(arc4random_uniform(2)) + 2 // 2 or 3
		}
        let newCode =  Array(parOne.prefix(crossPointOne)) + Array(parTwo[crossPointOne..<crossPointTwo]) + Array(parOne.suffix(parOne.count-crossPointTwo)) //NB not sure about the second slice (if notation is correct)
		return newCode
    }
}

//# change value at random index to a new random value
func mutation(code:[Int]) -> [Int] {
    var newCode = code
    let idx = Int(arc4random_uniform(4))
    newCode[idx] = Int(arc4random_uniform(5)+1)
    return newCode
}

//# swap the values at two random indices
func permutation(code:[Int]) -> [Int] {
	var newCode = code
    let idxOne = Int(arc4random_uniform(4))
    let idxTwo = Int(arc4random_uniform(4))
	(newCode[idxOne], newCode[idxTwo]) = (newCode[idxTwo], newCode[idxOne])
    return newCode
}

//# reverse part of the code between two random indices
func inversion(code:[Int]) -> [Int] {
    var poss = [0,1,2,3]
    let pointOneChoice = Int(arc4random_uniform(4))
	var pointOne = poss[pointOneChoice]
	poss.remove(at:pointOneChoice)
    var pointTwo = poss.random()
    if(pointTwo < pointOne){ //# make sure first has smallest value
        (pointOne, pointTwo) = (pointTwo, pointOne)
    }
    //# invert array between the two points
    let revPart = Array(code[pointOne...pointTwo].reversed()) //NB not sure about notation of slicing
	let firstPart = Array(code.prefix(pointOne))
	let lastPart = Array(code.suffix(code.count-pointTwo-1))
    let newCode = firstPart + revPart + lastPart
    return newCode
}

//# create a new generation of codes based on the fitnesses of the codes in the current generation
func developNewGeneration(currentGeneration:[[Int]], fitnesses:[Double], clues:[Clue], b:Int) -> [[Int]] {
    let maxSize = currentGeneration.count
    let onePCrossOverProb = 0.5
    let mutationProb = 0.03
    let permutationProb = 0.03
    let inversionProb = 0.02
    //# calculate selection chances based on fitnesses
	let constantTerm = max(0.0, Double(b*4*(max(0, clues.count-1)))) // constant term in this generation (==minimum fitness)
	let maxFitness = fitnesses.max()! // fitnesses will always be filled, since there cannot be an empty generation
	let selectionFitnesses = fitnesses.map{abs($0-(maxFitness-constantTerm))} // make sure low fitness has high selection chance and vice versa
	let totFitness = selectionFitnesses.reduce(0, +)
	let selectionChances = selectionFitnesses.map{Double($0)/totFitness}// divide every fitness value by totalfitness, to obtain selection chances
    var newGeneration = [[Int]]()
    while(newGeneration.count < maxSize){
        //# use crossover to generate a new code
		var newCode = applyCrossOver(population:currentGeneration, selectionChances:selectionChances, onePointCrossOverChance:onePCrossOverProb)
        
        if(drand48() <= mutationProb){ //# apply mutation -> change random index into random value
			newCode = mutation(code:newCode)
        }

        if(drand48() <= permutationProb){ //# apply permutation -> swap two random colors
			newCode = permutation(code:newCode)
        }

        if(drand48() <= inversionProb){ //# apply inversion -> invert order of colors between two random indices
			newCode = inversion(code:newCode)
        }
		while(newGeneration.map{$0 == newCode}.contains(true)){ //# no duplicates allowed: add random code
            newCode = chooseRandomCode()
        }

        newGeneration.append(newCode)
    }

    return newGeneration
}

//# calculate the fitness value of each code in the population, using the given clues (codes+feedback) and the parameters/weights a and b
func calculateFitness(population:[[Int]], clues:[Clue], a:Int, b:Int, ownCode:Bool) -> [Double] {
    let constantPart = Double(max(0, b*4*(clues.count-1))) //# b * number of colors in the code * (number of clues-1)
    var fitnesses = Array(repeating: constantPart, count: population.count) // create array of size "population.count" with values "constantPart"
    for x in 0...population.count-1 {
        for cl in clues {
            //# determine difference in feedback between actual code of the opponent and code x in the population
			let clueC = generateClue(att:cl.colorCode, colorCode:population[x], ownColorCode:nil)
            if(ownCode) {
                fitnesses[x] = fitnesses[x] + Double(a*(abs(clueC.blackPoints-cl.myBlackPoints)))
				fitnesses[x] = fitnesses[x] + Double(abs(clueC.whitePoints-cl.myWhitePoints))
            } else {
                fitnesses[x] = fitnesses[x] + Double(a*(abs(clueC.blackPoints-cl.blackPoints)))
				fitnesses[x] = fitnesses[x] + Double(abs(clueC.whitePoints-cl.whitePoints))
            }
        }
    }
    return fitnesses
}

func previousGuess(guess:[Int], clues:[Clue]) -> Bool {
    for cl in clues {
        if cl.colorCode==guess {
            return true
        }
    }
    return false
}

//# add codes from the population to the set of selected codes. Only adds codes that have a fitness of maximum "optimalFitness"
func addSelectedCodes(eligibleCodes:[[Int]], population:[[Int]], fitnesses:[Double], optimalFitness:Double, clues:[Clue]) -> [[Int]] {
    var out = eligibleCodes
    if(population.count != fitnesses.count){
        print("Error: array length mismatch between population and fitnesses in addSelectedCodes")
    }
    for x in 0...fitnesses.count-1 {
		if(fitnesses[x] <= optimalFitness && out.map{$0 == population[x]}.contains(true) == false) {
            if(previousGuess(guess:population[x], clues:clues)==false) {
                out.append(population[x])
            }
		}
    }
    return out
}

//# create a subset of the set of codes, used for code selection
func createSubSet(codes:[[Int]], maxSize:Int) -> [[Int]] {
    if(maxSize > codes.count){
        return codes
    } else {
        //# too many codes: select subset of size maxSize
        var subset = [[Int]]()
        for _ in 0...maxSize-1 {
            var code = codes.random()
			while(subset.map{$0 == code}.contains(true)){
                code = codes.random()
            }
            subset.append(code)
        }
        return subset
    }
}

//# calculate for every eligible code the expected information gain / expected number of eligible codes left after the attempt
func calculateSelectionValues(codes:[[Int]], a:Int, b:Int) -> [([Int], Double)] { // not sure about return type (list of tuples of list of integers and double)
    var selectionValues = [Double]()
	let subset = createSubSet(codes:codes, maxSize:20) //# create subset to evaluate codes on
    //# calculate estimated number of codes left per code
    for code in codes {
        var totRemainingEligibleCodes = 0.0
        for possibleSecretCode in subset{
			let clue = generateClue(att:code, colorCode:possibleSecretCode, ownColorCode:nil)
			let fitnesses = calculateFitness(population:subset, clues:[clue], a:a, b:b, ownCode:false) //# determine fitness according to clue and secret code
			totRemainingEligibleCodes += Double(fitnesses.filter{$0==0}.count) //# items with 0 fitness are eligible under the new clue
        }
        selectionValues.append(totRemainingEligibleCodes)
    }
    //# return codes with estimated info gain values (remaining eligible codes)
    return Array(zip(codes, selectionValues))
}

func calculateGiveAwayValues(codes:[[Int]], ownCode:[Int], a:Int, b:Int) -> [([Int], Double)] { // not sure about return type (list of tuples of list of integers and double)
    var giveAwayValues = [Double]()
    for code in codes {
		let clue = generateClue(att:code, colorCode:ownCode, ownColorCode:nil)
		let fitnesses = calculateFitness(population:codes, clues:[clue], a:a, b:b, ownCode:false)
		giveAwayValues.append(Double(fitnesses.filter{$0==0}.count))
    }
    return Array(zip(codes, giveAwayValues))
}

func geneticAlgorithm(clues:[Clue], ownCode:Bool, a:Int, b:Int, skillLevel:Double) -> [[Int]] {
    //# initialize genetic algorithm
    let maxgen = 100
    let maxsize = 10//Int(floor(60.0/Double(skillLevel*2)))//60
    let populationSize = 150
    var eligibleCodes = [[Int]]()
    var generation = 1
	var population = generateNewPopulation(size:populationSize)
    while (generation <= maxgen && eligibleCodes.count <= maxsize) || eligibleCodes.count == 0 {
        //# calculate fitnesses of the codes in the population
		let fitnesses = calculateFitness(population:population, clues:clues, a:a, b:b, ownCode:ownCode)
        //# add codes with optimal fitness to the set of eligible codes
        let optimalFitness = Double(max(0, Double(b)*skillLevel*Double((clues.count-1))))
        eligibleCodes = addSelectedCodes(eligibleCodes:eligibleCodes, population:population, fitnesses:fitnesses, optimalFitness:optimalFitness, clues:clues)
        if(eligibleCodes.count <= maxsize){ //# if room for more codes in the set, develop a new generation
			population = developNewGeneration(currentGeneration:population, fitnesses:fitnesses, clues:clues, b:b)
        }
        generation += 1
    }
    return eligibleCodes
}

func calculateStatistics(clues:[Clue], ownCode:[Int], skillLevel:Double) -> ([([Int], Double)]?, [([Int], Double)]){ // not sure about return type (tuple of lists of tuples, both lists of list of integers and doubles)
    let a = 2
    let b = 2
	if(clues.count==0){ //# start. no clues yet: only return giveAwayValues for codes selected by genAlg
        let giveAwayCodes = geneticAlgorithm(clues:clues, ownCode:true, a:a, b:b, skillLevel:skillLevel)
		let giveAwayValues = calculateGiveAwayValues(codes:giveAwayCodes, ownCode:ownCode, a:a, b:b)
        return (nil, giveAwayValues)
    } else {
        //# calculate estimated potential info gains
        let infoGainCodes = geneticAlgorithm(clues:clues, ownCode:false, a:a, b:b, skillLevel:skillLevel)
		if(infoGainCodes.count == 0){
			print("Error, no codes were found by the genetic algorithm!")
		}
		let infoGainValues = calculateSelectionValues(codes:infoGainCodes, a:a, b:b)
        //# calculate estimated potential info given away
        let giveAwayCodes = geneticAlgorithm(clues:clues, ownCode:true, a:a, b:b, skillLevel:skillLevel)
		let giveAwayValues = calculateGiveAwayValues(codes:giveAwayCodes, ownCode:ownCode, a:a, b:b)
        return (infoGainValues, giveAwayValues)
    }
}

func chooseAttempt(clues:[Clue], ownCode:[Int], skillLevel:Double) -> [Int]{
    //# infoGainValues consists of list of colorCodes with expected number of eligible codes left (lower number is more potential info gain)
    //# giveAwayValues consists of a same list, but then eligible codes FOR THE OPPONENT left (lower number is more potential info giveaway)

    //#cognitive model must decide what is best
    let (infoGainValues, giveAwayValues) = calculateStatistics(clues:clues, ownCode:ownCode, skillLevel:skillLevel)
	if(infoGainValues == nil){ // no info yet (first attempt): only giveAwayValues are provided
		// for now choose code with least info given away
		let (codes, giveAways) = unzip(giveAwayValues)
		let maxGiveAway = giveAways.max()! // max value means least info given away (since its first attempt, there is always a max)
		let indexMax = giveAways.index(of:maxGiveAway)! // see above
		return codes[indexMax]
	}
	// for now, choose the one with most info gain for AI
    let (codes, infogains) = unzip(infoGainValues!) // unwrap possible, o.w. in if above
	var minInfoGain = 0.0
	if(infogains.count > 0){
			minInfoGain = infogains.min()! // min value means most info gained
	} else {
		// should never happen (genetic algorithm did not find any code)
		print("Error: No code for info gain has been found.")
		exit(0)
	}
	let indexMin = infogains.index(of:minInfoGain)!
    return codes[indexMin]
	
}


func playGame(ownCode:[Int], opponentCode:[Int], skillLevel:Double) -> Int {
    var clues = [Clue]()
    var attempts = 1
    var attempt = chooseAttempt(clues:clues, ownCode:ownCode, skillLevel:skillLevel)
	print("Code attempted: \(attempt)")
	clues.append(generateClue(att:attempt, colorCode:opponentCode, ownColorCode:ownCode))
	while(attempt != opponentCode){
        attempts += 1
        attempt = chooseAttempt(clues:clues, ownCode:ownCode, skillLevel:skillLevel)
        print("Code attempted: \(attempt)")
		clues.append(generateClue(att:attempt, colorCode:opponentCode, ownColorCode:ownCode))
	}
	return attempts
}


let numrounds = 20
let all_codes = initializePossibilityList()
var results = [(Double, Double)]()
for x in 2...9 {
    var tot_attempts = 0
    let skillLevel = 4.0+Double(x)/20.0
    print("Started games with skill level \(skillLevel)")
    for x in 1...numrounds {
        let oppCode = all_codes.random()
        let ownCode = all_codes.random()
        print("\(x) code to crack: \(oppCode)")
        print("\(x) own code: \(ownCode)")
        let atts = playGame(ownCode:ownCode, opponentCode:oppCode, skillLevel:skillLevel)
        tot_attempts += atts
    }
    results.append((skillLevel, Double(tot_attempts)/Double(numrounds)))
    print("Average number of guesses: \(Double(tot_attempts)/Double(numrounds))")
}
print("Run completed")
print("Results:")
for (skill, attempts) in results{
    print("Skilllevel \(skill): \(attempts) needed on average")
}

