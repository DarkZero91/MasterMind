import random

########################### useful subclasses ################################
class Clue(object):

	def __init__(self, colorCode, whitePoints, blackPoints, myWhitePoints, myBlackPoints):

		self.colorCode = colorCode		   # attempted code
		self.whitePoints = whitePoints 	   # number of white points (correct color on wrong place)
		self.blackPoints = blackPoints     # number of black points (correct color on right place)
		self.myWhitePoints = myWhitePoints # number of white points about own code
		self.myBlackPoints = myBlackPoints # number of black points about own code

	def __eq__(self, other):
		return self.colorCode==other.colorCode and self.whitePoints==other.whitePoints and self.blackPoints==other.blackPoints and self.myBlackPoints==other.myBlackPoints and 				self.myWhitePoints==other.myWhitePoints

	def __str__(self):
		return "Colorcode: "+str(self.colorCode)+", whitePoints: "+str(self.whitePoints)+", blackPoints: "+str(self.blackPoints)

################################# GENERAL FUNCTIONS ###################################
def chooseRandomCodeFromList(possibilities):
	return random.choice(possibilities)

def chooseRandomCode():
	att = []
	for x in range(4):
		att.append(random.randint(1,6))
	return att

def initializePossibilityList():

	colors = [1,2,3,4,5,6]
	all_combinations = []
	for x1 in range(1,1+len(colors)):
		for x2 in range(1,1+len(colors)):
			for x3 in range(1,1+len(colors)):
				for x4 in range(1,1+len(colors)):
					all_combinations.append([x1,x2,x3,x4])
	return all_combinations

def generateClue(att, colorCode, ownColorCode=None):
	attempt = list(att) # make sure copy is modified
	code = list(colorCode) # idem
	wp = 0
	bp = 0
	mywp = 0
	mybp = 0
	if(ownColorCode!=None):
		myattempt = list(att)
		ownCode = list(ownColorCode)
	for x  in range(len(attempt)):
		if attempt[x]==code[x]:
			bp += 1
			attempt[x] = 0
			code[x] = 0
		if(ownColorCode!=None):
			if myattempt[x]==ownCode[x]:
				mybp += 1
				myattempt[x] = 0
				ownCode[x] = 0
		
	if(bp!=4):
		for x in range(len(attempt)):
			if attempt[x]!=0 and attempt[x] in code:
				wp += 1
				code[code.index(attempt[x])] = 0

	if(ownColorCode!=None and mybp!=4):
		for x in range(len(myattempt)):
			if myattempt[x]!=0 and myattempt[x] in ownCode:
				mywp += 1
				ownCode[ownCode.index(myattempt[x])] = 0
	return Clue(att, wp, bp, mywp, mybp)

################################## GENETIC ALGORITHM #####################################

# generate a new population with "size" random codes
def generateNewPopulation(size):
	population = []
	while(len(population)<size):
		code = chooseRandomCode()
		while(code in population): # only unique codes
			code = chooseRandomCode()
		population.append(code)
	return population

# select a code to act as a parent, using chances for each code and a randomly selected value between 0 and 1
def selectParent(chances, value):
	tot = 0.0
	for x in range(len(chances)):
		tot += chances[x]
		# if total value becomes bigger than randomly selected number, return index 
		if(tot >= value):
			return x
    

# apply cross over between two parents
def applyCrossOver(population, selectionChances, onePointCrossOverChance):
	# select two parents
	parOne = population[selectParent(selectionChances, random.random())]
	parTwo = population[selectParent(selectionChances, random.random())]
	if(random.random()<=onePointCrossOverChance): # apply one-point crossover
		crossPoint = random.randint(1,3)
		return parOne[:crossPoint] + parTwo[crossPoint:]
	else: # apply two-point crossover
		crossPointOne = random.choice([1,2])
		if(crossPointOne == 1):
			crossPointTwo = random.choice([2,3])
		else:
			crossPointTwo = 2
		return parOne[:crossPointOne] + parTwo[crossPointOne:crossPointTwo] + parOne[crossPointTwo:]

# change value at random index to a new random value
def mutation(code):
	newCode = code
	idx = random.randint(0,3)
	newCode[idx] = random.randint(0,5)
	return newCode

# swap the values at two random indices
def permutation(code):
	idxOne = random.randint(0,3)
	idxTwo = random.randint(0,3)
	newCode = code
	newCode[idxOne], newCode[idxTwo] = newCode[idxTwo], newCode[idxOne]
	return newCode

# reverse part of the code between two random indices
def inversion(code):
	poss = list(range(4))
	pointOne = random.choice(poss)
	poss.remove(pointOne)
	pointTwo = random.choice(poss)
	if(pointTwo<pointOne): # make sure first has smallest value
		pointOne, pointTwo = pointTwo, pointOne
	# invert array between the two points
	revPart = list(reversed(code[pointOne:pointTwo]))
	newCode = code[:pointOne] + revPart + code[pointTwo:]
	return newCode

# create a new generation of codes based on the fitnesses of the codes in the current generation
def developNewGeneration(currentGeneration, fitnesses):
	maxSize = len(currentGeneration)
	onePCrossOverProb = 0.5
	mutationProb = 0.03
	permutationProb = 0.03
	inversionProb = 0.02
	# calculate selection chances based on fitnesses
	totFitness = sum(fitnesses)
	selectionChances = [float(x)/totFitness for x in fitnesses] #problem: high fitness is bad, but now gets higher chance to be chosen
	newGeneration = []
	while(len(newGeneration)<maxSize):
		# use crossover to generate a new code
		newCode = applyCrossOver(population=currentGeneration, selectionChances=selectionChances, onePointCrossOverChance=onePCrossOverProb)
		
		if(random.random()<=mutationProb): # apply mutation -> change random index into random value
			newCode = mutation(code=newCode)

		if(random.random()<=permutationProb): # apply permutation -> swap two random colors
			newCode = permutation(code=newCode)

		if(random.random()<=inversionProb): # apply inversion -> invert order of colors between two random indices
			newCode = inversion(code=newCode) 

		while(newCode in newGeneration): # no duplicates allowed: add random code
			newCode = chooseRandomCode()

		newGeneration.append(newCode)

	return newGeneration

# calculate the fitness value of each code in the population, using the given clues (codes+feedback) and the parameters/weights a and b
def calculateFitness(population, clues, a, b, ownCode):
	constantPart = b*4*(len(clues)-1) # b * number of colors in the code * (number of clues-1)
	fitnesses = [constantPart] * len(population)
	for x in range(len(population)):
		for cl in clues:
			# determine difference in feedback between actual code of the opponent and code x in the population
			clueC = generateClue(att=cl.colorCode, colorCode=population[x])
			if(ownCode):
				fitnesses[x] = fitnesses[x] + a*(abs(clueC.blackPoints-cl.myBlackPoints)) + abs(clueC.whitePoints-cl.myWhitePoints)
			else:
				fitnesses[x] = fitnesses[x] + a*(abs(clueC.blackPoints-cl.blackPoints)) + abs(clueC.whitePoints-cl.whitePoints)
	return fitnesses

# add codes from the population to the set of selected codes. Only adds codes that have a fitness of maximum "optimalFitness"
def addSelectedCodes(eligibleCodes, population, fitnesses, optimalFitness):
	out = eligibleCodes
	if(len(population)!= len(fitnesses)):
		print("Error: array length mismatch between population and fitnesses in addSelectedCodes")
		return
	for x in range(len(fitnesses)):
		if(fitnesses[x]<=optimalFitness and population[x] not in out):
			out.append(population[x])
	return out

# create a subset of the set of codes, used for code selection
def createSubSet(codes, maxSize):
	if(maxSize>len(codes)):
		return codes
	else:
		# too many codes: select subset of size maxSize
		subset = []
		for x in range(maxSize):
			code = random.choice(codes)
			while(code in subset):
				code = random.choice(codes)
			subset.append(code)
		return subset

# calculate for every eligible code the expected information gain / expected number of eligible codes left after the attempt
def calculateSelectionValues(codes, a, b):
	selectionValues = []
	subset = createSubSet(codes=codes, maxSize=20) # create subset to evaluate codes on
	# calculate estimated number of codes left per code
	for code in codes:
		totRemainingEligibleCodes = 0
		for possibleSecretCode in subset:
			clue = generateClue(att=code, colorCode=possibleSecretCode)
			fitnesses = calculateFitness(population=subset, clues=[clue], a=a, b=b, ownCode=False) # determine fitness according to clue and secret code
			totRemainingEligibleCodes += len([x for x in fitnesses if x==0]) # items with 0 fitness are eligible under the new clue
		selectionValues.append(totRemainingEligibleCodes)
	# return codes with estimated info gain values (remaining eligible codes)
	return zip(codes, selectionValues)

def calculateGiveAwayValues(codes, ownCode, a, b):
	giveAwayValues = []
	for code in codes:
		clue = generateClue(att=code, colorCode=ownCode)
		fitnesses = calculateFitness(population=codes, clues=[clue], a=a, b=b, ownCode=False) # NB owncode must be false here too, since the default white/blackpoints values must be used
		giveAwayValues.append(len([x for x in fitnesses if x==0]))
	return zip(codes, giveAwayValues)

def geneticAlgorithm(clues, ownCode, a, b):
	# initialize genetic algorithm
	maxgen = 100
	maxsize = 60
	populationSize = 150
	eligibleCodes = []
	generation = 1
	population = generateNewPopulation(populationSize)
	while generation<=maxgen and len(eligibleCodes)<=maxsize: 
		# calculate fitnesses of the codes in the population
		fitnesses = calculateFitness(population, clues, a, b, ownCode=ownCode)
		# add codes with optimal fitness to the set of eligible codes
		eligibleCodes = addSelectedCodes(eligibleCodes, population, fitnesses, optimalFitness=b*4*(len(clues)-1))
		if(len(eligibleCodes)<=maxsize): # if room for more codes in the set, develop a new generation
			population = developNewGeneration(population, fitnesses)
		generation += 1
	return eligibleCodes

def calculateStatistics(clues, ownCode):
	a = 2
	b = 2
	if(clues == []): # start. no clues yet: only return gievAwayValues for codes selected by genAlg
		giveAwayCodes = geneticAlgorithm(clues, ownCode=True, a=a, b=b)
		giveAwayValues = calculateGiveAwayValues(codes=giveAwayCodes, ownCode=ownCode, a=a, b=b)
		return None, giveAwayValues
	else:
		# calculate estimated potential info gains
		infoGainCodes = geneticAlgorithm(clues, ownCode=False, a=a, b=b)
		infoGainValues = calculateSelectionValues(codes=infoGainCodes, a=a, b=b)
		# calculate estimated potential info given away
		giveAwayCodes = geneticAlgorithm(clues, ownCode=True, a=a, b=b)
		giveAwayValues = calculateGiveAwayValues(codes=giveAwayCodes, ownCode=ownCode, a=a, b=b)
		return infoGainValues, giveAwayValues

def chooseAttempt(clues, ownCode):
	# infoGainValues consists of list of colorCodes with expected number of eligible codes left (lower number is more potential info gain)
	# giveAwayValues consists of a same list, but then eligible codes FOR THE OPPONENT left (lower number is more potential info giveaway)
	# cognitive model must decide what is best
	infoGainValues, giveAwayValues = calculateStatistics(clues, ownCode)
	if(infoGainValues==None): # no info yet (first attempt): only giveAwayValues are provided
		# for now choose code with least info given away
		codes, giveAways = zip(*giveAwayValues)
		return codes[giveAways.index(max(giveAways))]

	#for now, choose the one with most info gain for AI
	codes, infogains = zip(*infoGainValues)
	return codes[infogains.index(min(infogains))]


def playGame(ownCode, opponentCode):
	clues = []
	attempts = 1
	attempt = chooseAttempt(clues, ownCode)
	while(attempt!=opponentCode):
		attempts += 1
		attempt = chooseAttempt(clues, ownCode)
		print("Code attempted: "+str(attempt))
		clues.append(generateClue(attempt, opponentCode, ownCode))
	return attempts

numrounds = 10
all_codes = initializePossibilityList()
tot_attempts = 0
for x in range(numrounds):
	oppCode = random.choice(all_codes)
	ownCode = random.choice(all_codes)
	print(str(x)+ " code to crack: "+str(oppCode))
	print(str(x)+ " own code: "+str(ownCode))
	atts = playGame(ownCode, oppCode)
	tot_attempts += atts
print("Average number of guesses: "+str(tot_attempts/numrounds))
