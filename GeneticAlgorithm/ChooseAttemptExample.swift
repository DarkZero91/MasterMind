func chooseAttempt(attempts:[Attempt]) -> [Int] {
	print("In chooseAttempt of AI")
	if(attempts.count > 0 && attempts.last!.getPlayer2Feedback().black==4){
		// opponent has tried its own code: make use of it
		return attempts.last!.choice
	}
	let (codes, infoGainValues, giveAwayValues) = brains.chooseAttempt(attempts: attempts, ownCode: code, skillLevel: skillLevel)
	if(codes.count==0){
		// should never happen
		print("Error: no codes were generated.")
		exit(0)
	}
	if(infoGainValues == nil){ // no info yet (first attempt): only giveAwayValues are provided
		// should not happen anymore
		let maxGiveAway = giveAwayValues.max()! // max value means least info given away (since its first attempt, there is always a max)
		let indexMax = giveAwayValues.index(of:maxGiveAway)! // see above
		let chosenCode = codes[indexMax]
		return chosenCode
	} else {
		// for now, always choose the one with most info gain for AI
		var minInfoGain = 0.0
		if(infoGainValues.count > 0){
			minInfoGain = infoGainValues.min()! // min value means most info gained
		} else {
			// should never happen (genetic algorithm did not find any code)
			print("Error: No code for info gain has been found.")
			exit(0)
		}
		let indexMin = infoGainValues.index(of:minInfoGain)!
		let chosenCode = codes[indexMin]
		return chosenCode
	}
}
