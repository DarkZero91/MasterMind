//
//  ViewController.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var widthMultiplier = 0.0
    var heightMultiplier = 0.0
    var fillButton = 0
	var totGames = 0
	var totAttempts = 0
	var game = MasterMind(avgGuess:5.0)
    
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var upperText: UILabel!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet var colorSelection: [UIButton]!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet var opponentEvals: [UILabel]!
    @IBOutlet var playerEvals: [UILabel]!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet var playerCodeLabels: [UILabel]!
    @IBOutlet var aiCodeLabels: [UILabel]!
    @IBOutlet weak var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        widthMultiplier = Double(self.view.frame.size.width) / 375
        heightMultiplier = Double(self.view.frame.size.height) / 667
        scaleView(labels: allLabels)
        scaleView(buttons: allButtons)
		confirmButton.isHidden = true
        circleButtons(buttons: Buttons)
        circleButtons(buttons: colorSelection)
        circleButtons(labels: playerCodeLabels)
        circleButtons(labels: aiCodeLabels)
        setCode(code:game.player2.code,labels:playerCodeLabels)
        setCode(code:game.player1.code,labels:aiCodeLabels)
		// is at the start of a game, and AI begins, simulate AI's turn
		if(game.start){
			if(self.totGames==0){ // no data yet, set to standard 5.0
				game.player1.setSkillLevel(averageGuesses: 5.0)
			} else {
				game.player1.setSkillLevel(averageGuesses:Double(self.totAttempts/self.totGames)) // create new empty game, with skill level
			}
		}
		if(game.userStarts==false){
			aiTurn()
		}
    }

    func setCode(code:[Int], labels:[UILabel]!){
        for x in 0...3{
            switch code[x]{
                case 1: labels[x].backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                case 2: labels[x].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
                case 3: labels[x].backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                case 4: labels[x].backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case 5: labels[x].backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
                case 6: labels[x].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                default: print("could not find code")
            }
        }
    }
    
    func scaleView(labels:[UILabel]!){
        for label in labels{
            label.frame.size.width = label.frame.width * CGFloat(widthMultiplier)
            label.frame.size.height = label.frame.height * CGFloat(heightMultiplier)
            label.frame.origin = CGPoint(x: label.frame.origin.x * CGFloat(widthMultiplier), y: label.frame.origin.y * CGFloat(heightMultiplier))
        }
    }
    
    func scaleView(buttons:[UIButton]!){
        for button in buttons{
            button.frame.size.width = button.frame.width * CGFloat(widthMultiplier)
            button.frame.size.height = button.frame.height * CGFloat(heightMultiplier)
            button.frame.origin = CGPoint(x: button.frame.origin.x * CGFloat(widthMultiplier), y: button.frame.origin.y * CGFloat(heightMultiplier))
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    func circleButtons(buttons:[UIButton]!){
        for button in buttons{
            button.layer.cornerRadius = (button.frame.width)/2
            button.clipsToBounds = true
        }
    }
    
    func circleButtons(labels:[UILabel]!){
        for label in labels{
            label.layer.cornerRadius = (label.frame.width)/2
            label.clipsToBounds = true
        }
    }
    
    @IBAction func fillColor(_ sender: UIButton) {
        for color in colorSelection{
            color.isHidden = false
        }
        fillButton = Buttons.index(of: sender)!
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let currentButton = colorSelection.index(of: sender)!
        Buttons[fillButton].backgroundColor = colorSelection[currentButton].backgroundColor
        for color in colorSelection{
            color.isHidden = true
        }
		if(completeCode()){
			// code is completed: confirm button can be shown
			confirmButton.isHidden = false
		}
    }
	
	// checks if all places in the code are filled with a color
	func completeCode() -> Bool {
		let turn = game.getTurn() - 1
		for x in 0...3 {
			if Buttons[x + (4*turn)].backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
				return false
			}
		}
		return true
	}
	
	// function to call by AI: fill a button with a selected color
	func colorButton(index:Int, colorValue:Int) {
		let color = code2color(color: colorValue)
		// NB: assumes the buttons are indexed in the same order as they appear on the screen (0,1,2,3 in upper row, 4,5,6,7 in second row, etc.)
		Buttons[index].backgroundColor = color
		Buttons[index].isEnabled = false
	}
	
	// generates feedback on attempt, draws it on the screen, checks for a winner, and switches turns
	func drawNewAttempt(code:[Int]) {
		print("\(game.getTurn()): \(code) by player \(game.getPlayerTurn().name)")
		let attempt = game.checkCode(choice: code)

		
		drawFeedbacks(attempt: attempt)
		//DispatchQueue.main.async {
			//while(self.game.player_turn.getname()==self.game.player1.getname()){
				//self.aiTurn()
			//}
		//}
		if upperText.text != "You lose" && upperText.text != "You win"{
			checkWinner()
		}
		confirmButton.isHidden = true
		if (upperText.text != "You lose" && upperText.text != "You win"){
			if (game.player_turn.getname()==game.player2.getname()){
				upperText.text = "Opponents turn"
				game.switchTurn()
				aiTurn()
			} else {
				upperText.text = "Your turn"
				game.switchTurn()
			}
		}
		
	}
	
	func aiTurn(){
		let code = game.simulateAITurn()
		for i in 0...3{
			let c = code[i]
			//TODO fill the right button with the color
			let buttonindex = game.attempts.count*4 + i
			colorButton(index:buttonindex, colorValue:c)
		}
		drawNewAttempt(code: code)
	}
	
	@IBAction func confirmChoice(_ sender: Any) {
		var selectedCode = [Int]()
		let turn = game.getTurn() - 1
		upperText.text = "Opponents turn"
		// generate selected code as Int array
        for x in 0...3{
            selectedCode.append(color2code(ind: x + (4*turn)))
            Buttons[x+(4*turn)].isEnabled = false
        }
		// evaluate and draw feedbacks
		drawNewAttempt(code: selectedCode)
    }
    
    func checkWinner(){
		let turn = game.getTurn() - 1
        if upperText.text != "You win" && upperText.text != "You lose"{
            turnLabel.text = "Turn: \(turn+1)"
            if turn < 8{
                for x in 0...3{
                    Buttons[x + (4*turn)].isEnabled = true
                    Buttons[x + (4*turn)].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            } else{
                upperText.text = "You lose"
                confirmButton.isHidden = true
            }
        }
    }
    
	func drawFeedbacks(attempt:Attempt){
		let turn = game.getTurn() - 2
		let (p1Black, p1White) = attempt.getPlayer1Feedback()
		opponentEvals[turn].text? = "" // make sure start with empty string
		opponentEvals[turn].text?.append(String(repeating: "⚫️", count: p1Black))
		opponentEvals[turn].text?.append(String(repeating: "⚪️", count: p1White))
		let (p2Black, p2White) = attempt.getPlayer2Feedback()
		playerEvals[turn].text? = "" // make sure start with empty string
		playerEvals[turn].text?.append(String(repeating: "⚫️", count: p2Black))
		playerEvals[turn].text?.append(String(repeating: "⚪️", count: p2White))
        //is there a winner?
        if (p1Black == 4 && attempt.player.getname()==game.player2.getname()){
            upperText.text = "You win"
            confirmButton.isHidden = true
            for x in aiCodeLabels{
                x.isHidden = false
            }
            turnLabel.text = "Opponents code:"
        }
		if (p2Black == 4 && attempt.player.getname()==game.player1.getname()){
            upperText.text = "You lose"
            confirmButton.isHidden = true
            for x in aiCodeLabels{
                x.isHidden = false
            }
            turnLabel.text = "Opponents code:"
        }
    }
	
    func color2code(ind:Int) -> Int{
        //buttonColor = Buttons[ind].backgroundColor
        switch Buttons[ind].backgroundColor! {
        case colorSelection[0].backgroundColor!: return 1
        case colorSelection[1].backgroundColor!: return 2
        case colorSelection[2].backgroundColor!: return 3
        case colorSelection[3].backgroundColor!: return 4
        case colorSelection[4].backgroundColor!: return 5
        case colorSelection[5].backgroundColor!: return 6
        default: print("could not find a value for color: \(Buttons[ind].backgroundColor!)"); return 0
        }
    }
	
	func code2color(color:Int) -> UIColor {
		switch color {
		case 1: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
		case 2: return #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
		case 3: return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
		case 4: return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
		case 5: return #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
		case 6: return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
		default: print("Error, no color found for value \(color)"); return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		}
	}

	func updateStats(){
		// only needed when game was over
		if(upperText.text=="You won" || upperText.text=="You lose"){
			self.totGames += 1
			if(upperText.text=="You won"){
				self.totAttempts += (self.game.attempts.count-1) // add number of guesses that was needed, minus one
			} else {
				if(upperText.text=="You lose"){
					self.totAttempts += 9 // add max guesses + 1???
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("In prepare")
		updateStats() // update game history stats, needed for adaptive AI
		
		if segue.identifier == "gameToCode" {
			let codeController = segue.destination as! codeSelectionViewController
			codeController.totGames = self.totGames
			codeController.totAttempts = self.totAttempts

		}
	}
    
    @IBAction func reset(_ sender: Any) {
		print("In reset")
        for x in 0...(Buttons.endIndex-1) {
            Buttons[x].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Buttons[x].isEnabled = true
            if x > 3{
                Buttons[x].isEnabled = false
                Buttons[x].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5038259846)
            } else {
                Buttons[x].isEnabled = true
            }
        }
        for x in 0...(playerEvals.endIndex-1){
            playerEvals[x].text = ""
        }
        turnLabel.text = "Turn: 1"
        upperText.text = "Your turn"
        confirmButton.isHidden = false
    }
    

}

