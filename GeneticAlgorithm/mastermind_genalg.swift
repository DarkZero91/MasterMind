//
//  Clue.swift
//  MasterMind
//
//  Created by R. Elderman on 06/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//
import Foundation

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
    att = [Int]()
    for x in 0...4 {
        //append random value between 1 and 6
        att.append(arc4random_uniform(6) + 1)
    }
    return att
}

func initializePossibilityList() -> [[Int]] {
    //generate all possible colorcodes, assume 4 positions and 6 different colors
    all_combinations = [[Int]]()
    for x1 in 1...7:
        for x2 in 1...7:
            for x3 in 1...7:
                for x4 in 1...7:
                    all_combinations.append([x1,x2,x3,x4])
    return all_combinations
}

func generateClue(att:[Int], colorCode:[Int], ownColorCode:[Int]=nil) -> Clue {
    attempt = att // make sure copy is modified (this might be enough in swift?)
    code = colorCode // idem
    wp = 0
    bp = 0
    mywp = 0
    mybp = 0
    if(ownColorCode!=nil){
        myattempt = att
        ownCode = ownColorCode
    }
    for x in 0...attempt.count{
        if attempt[x]==code[x]{
            bp += 1
            attempt[x] = 0
            code[x] = 0
        }
        if(ownColorCode!=nil){
            if myattempt[x]==ownCode[x]{
                mybp += 1
                myattempt[x] = 0
                ownCode[x] = 0
            }
        }
    }
        
    if(bp!=4){
        for x in 0...attempt.count{
            if attempt[x]!=0 && code.contains(attempt[x]){
                wp += 1
                code[code.index(attempt[x])] = 0
            }
        }
    }

    if(ownColorCode!=nil && mybp!=4){
        for x in 0...attempt.count{
            if myattempt[x]!=0 && ownCode.contains(myattempt[x]){
                mywp += 1
                ownCode[ownCode.index(myattempt[x])] = 0
            }
        }
    }
    return Clue(att, wp, bp, mywp, mybp)
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
    population = [[Int]]
    while(population.count<size){
        code = chooseRandomCode()
        while(population.contains(code)){ //# only unique codes
            code = chooseRandomCode()
        }
        population.append(code)
    }
    return population
}

//# select a code to act as a parent, using chances for each code and a randomly selected value between 0 and 1
func selectParent(chances:[Double], value:Double) -> Int:
    tot = 0
    for x in 0...chances.count{
        tot += chances[x]
        //# if total value becomes bigger than randomly selected number, return index 
        if(tot >= value){
            return x
        }
    }

//# apply cross over between two parents
func applyCrossOver(population:[Int8], selectionChances:[Double], onePointCrossOverChance:Double) -> [Int]{
    //# select two parents
    parOne = population[selectParent(selectionChances, drand48())]
    parTwo = population[selectParent(selectionChances, drand48())]
    if(drand48()<=onePointCrossOverChance){ //# apply one-point crossover
        crossPoint = arc4random_uniform(2) + 1 // 1 or 2
        return parOne[..<crossPoint] + parTwo[crossPoint...] 
    } else { //# apply two-point crossover
        crossPointOne = arc4random_uniform(2) + 1 // 1 or 2
        if(crossPointOne == 1){
            crossPointTwo = arc4random_uniform(2) + 2 // 2 or 3
        } else {
            crossPointTwo = 2
        }
        return parOne[..<crossPointOne] + parTwo[crossPointOne..<crossPointTwo] + parOne[crossPointTwo...] //NB not sure about the second slice (if notation is correct)
    }
}

//# change value at random index to a new random value
func mutation(code:[Int]) -> [Int] {
    newCode = code
    idx = arc4random_uniform(4)
    newCode[idx] = arc4random_uniform(5)
    return newCode
}

//# swap the values at two random indices
func permutation(code:[Int]) -> [Int] {
    idxOne = arc4random_uniform(4)
    idxTwo = arc4random_uniform(4)
    newCode = code
    (newCode[idxOne], newCode[idxTwo]) = (newCode[idxTwo], newCode[idxOne])
    return newCode
}

//# reverse part of the code between two random indices
func inversion(code:[Int]) -> [Int] {
    poss = [0,1,2,3]
    pointOne = poss.random()
    poss.remove(pointOne)
    pointTwo = poss.random()
    if(pointTwo<pointOne){ //# make sure first has smallest value
        (pointOne, pointTwo) = (pointTwo, pointOne)
    }
    //# invert array between the two points
    revPart = Array(code[pointOne...pointTwo].reversed()) //NB not sure about notation of slicing
    newCode = code[..<pointOne] + revPart + code[pointTwo...]
    return newCode
}

//# create a new generation of codes based on the fitnesses of the codes in the current generation
func developNewGeneration(currentGeneration:[[Int]], fitnesses[Double]) -> [[Int]] {
    maxSize = currentGeneration.count
    onePCrossOverProb = 0.5
    mutationProb = 0.03
    permutationProb = 0.03
    inversionProb = 0.02
    //# calculate selection chances based on fitnesses
    totFitness = fitnesses.reduce(0, +) //total fitness
    selectionChances = fitnesses.map { $0 / totFitness } // divide every fitness value by totalfitness, to obtain selection chances
    newGeneration = [[Int]]
    while(newGeneration.count<maxSize){
        //# use crossover to generate a new code
        newCode = applyCrossOver(currentGeneration, selectionChances, onePCrossOverProb)
        
        if(drand48()<=mutationProb){ //# apply mutation -> change random index into random value
            newCode = mutation(newCode)
        }

        if(drand48()<=permutationProb){ //# apply permutation -> swap two random colors
            newCode = permutation(newCode)
        }

        if(drand48()<=inversionProb){ //# apply inversion -> invert order of colors between two random indices
            newCode = inversion(newCode)
        } 

        while(newGeneration.contains(newCode)){ //# no duplicates allowed: add random code
            newCode = chooseRandomCode()
        }

        newGeneration.append(newCode)
    }

    return newGeneration
}

//# calculate the fitness value of each code in the population, using the given clues (codes+feedback) and the parameters/weights a and b
func calculateFitness(population:[[Int]], clues:[Clue], a:Int, b:Int, ownCode:[Int]) -> [Double] {
    constantPart = b*4*(clues.count-1) //# b * number of colors in the code * (number of clues-1)
    fitnesses = Array(repeating: constantPart, count: population.count) // create array of size "population.count" with values "constantPart"
    for x in 0...population.count {
        for cl in clues {
            //# determine difference in feedback between actual code of the opponent and code x in the population
            clueC = generateClue(cl.colorCode, population[x])
            if(ownCode) {
                fitnesses[x] = fitnesses[x] + a*(abs(clueC.blackPoints-cl.myBlackPoints)) + abs(clueC.whitePoints-cl.myWhitePoints)
            } else {
                fitnesses[x] = fitnesses[x] + a*(abs(clueC.blackPoints-cl.blackPoints)) + abs(clueC.whitePoints-cl.whitePoints)
            }
        }
    }
    return fitnesses
}

//# add codes from the population to the set of selected codes. Only adds codes that have a fitness of maximum "optimalFitness"
func addSelectedCodes(eligibleCodes:[[Int]], population:[[Int]], fitnesses:[Double], optimalFitness:Double) -> [[Int]] {
    out = eligibleCodes
    if(population.count!= fitnesses.count){
        print("Error: array length mismatch between population and fitnesses in addSelectedCodes")
        return
    }
    for x in 0...fitnesses.count {
        if(fitnesses[x]<=optimalFitness && out.contains(population[x])==false):
            out.append(population[x])
    }
    return out
}

//# create a subset of the set of codes, used for code selection
func createSubSet(codes:[[Int]], maxSize:Int) -> [[Int]] {
    if(maxSize>codes.count){
        return codes
    } else {
        //# too many codes: select subset of size maxSize
        subset = [[Int]]
        for x in 0..maxSize{
            code = codes.random()
            while(subset.contains(code)){
                code = codes.random()
            }
            subset.append(code)
        }
        return subset
    }
}

//# calculate for every eligible code the expected information gain / expected number of eligible codes left after the attempt
func calculateSelectionValues(codes:[[Int]], a:Int, b:Int) -> [[Int], Double] { // not sure about return type (list of tuples of list of integers and double)
    selectionValues = [Double]
    subset = createSubSet(codes, 20) //# create subset to evaluate codes on
    //# calculate estimated number of codes left per code
    for code in codes {
        totRemainingEligibleCodes = 0
        for possibleSecretCode in subset{
            clue = generateClue(code, possibleSecretCode)
            fitnesses = calculateFitness(subset, [clue], a, b, false) //# determine fitness according to clue and secret code
            totRemainingEligibleCodes += fitnesses.filter($0==0).count //# items with 0 fitness are eligible under the new clue
        }
        selectionValues.append(totRemainingEligibleCodes)
    }
    //# return codes with estimated info gain values (remaining eligible codes)
    return Array(Zip2(codes, selectionValues))
}

func calculateGiveAwayValues(codes:[[Int]], ownCode:[Int], a:Int, b:Int) -> [[Int], Double] { // not sure about return type (list of tuples of list of integers and double)
    giveAwayValues = [Double]
    for code in codes {
        clue = generateClue(code, ownCode)
        fitnesses = calculateFitness(codes, [clue], a, b, false)
        giveAwayValues.append(fitnesses.filter($0==0).count)
    }
    return Array(Zip2(codes, giveAwayValues))
}

func geneticAlgorithm(clues:[Clue], ownCode:[Int], a:Int, b:Int) -> [[Int]] {
    //# initialize genetic algorithm
    maxgen = 100
    maxsize = 60
    populationSize = 150
    eligibleCodes = [[Int]]
    generation = 1
    population = generateNewPopulation(populationSize)
    while generation<=maxgen && eligibleCodes.count<=maxsize { 
        //# calculate fitnesses of the codes in the population
        fitnesses = calculateFitness(population, clues, a, b, ownCode)
        //# add codes with optimal fitness to the set of eligible codes
        eligibleCodes = addSelectedCodes(eligibleCodes, population, fitnesses, b*4*(clues.count-1))
        if(eligibleCodes.count<=maxsize){ //# if room for more codes in the set, develop a new generation
            population = developNewGeneration(population, fitnesses)
        }
        generation += 1
    }
    return eligibleCodes
}

func calculateStatistics(clues:[Clue], ownCode:[Int]) -> ([[Int], Double], [[Int], Double]){ // not sure about return type (tuple of lists of tuples, both lists of list of integers and doubles)
    a = 2
    b = 2
    if(clues.isEmpty()){ //# start with random guess
        return nil, nil
    } else {
        //# calculate estimated potential info gains
        infoGainCodes = geneticAlgorithm(clues, false, a, b)
        infoGainValues = calculateSelectionValues(infoGainCodes, a, b)
        //# calculate estimated potential info given away
        giveAwayCodes = geneticAlgorithm(clues, true, a, b)
        giveAwayValues = calculateGiveAwayValues(giveAwayCodes, ownCode, a, b)
        return infoGainValues, giveAwayValues
    }
}

func chooseAttempt(clues:[Clue], ownCode:[Int]) -> [Int]{
    infoGainValues, giveAwayValues = calculateStatistics(clues, ownCode)
    if(infoGainValues==nil && giveAwayValues==nil){
        return chooseRandomCode()
    }
    //# infoGainValues consists of list of colorCodes with expected number of eligible codes left (lower number is more potential info gain)
    //# giveAwayValues consists of a same list, but then eligible codes FOR THE OPPONENT left (lower number is more potential info giveaway)

    //#cognitive model must decide what is best: for now, choose the one with most info gain for AI
    codes, infogains = unzip(infoGainValues)
    return codes[infogains.index(of:min(infogains))]
    //# codes, giveAways = zip(*giveAwayValues)
    //# return codes[giveAways.index(max(giveAways))]
}


func playGame(ownCode:[Int], opponentCode[Int]) -> Int {
    clues = [Clue]
    attempts = 1
    attempt = chooseAttempt(clues, ownCode)
    while(attempt!=opponentCode):
        attempts += 1
        attempt = chooseAttempt(clues, ownCode)
        print("Code attempted: \(attempt)")
        clues.append(generateClue(attempt, opponentCode, ownCode))
    return attempts
}


numrounds = 10
all_codes = initializePossibilityList()
tot_attempts = 0
for x in 0...numrounds:
    oppCode = all_codes.random()
    ownCode = all_codes.random()
    print("\(x) code to crack: \(oppCode)")
    print("\(x) own code: \(ownCode)")
    atts = playGame(ownCode, oppCode)
    tot_attempts += atts
print("Average number of guesses: \(tot_attempts/numrounds)")