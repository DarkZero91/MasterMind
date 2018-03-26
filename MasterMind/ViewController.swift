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
	var game = MasterMind()
    
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
        setCode()

    }

    func setCode(){
		let code = game.player2.code
        for x in 0...3{
            switch code[x]{
                case 1: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                case 2: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
                case 3: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                case 4: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case 5: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
                case 6: playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
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
	
	func drawNewAttempt(code:[Int]) {
		print("\(game.getTurn()): \(code)")
		let attempt = game.checkCode(choice: code)
		drawFeedbacks(attempt: attempt)
		if upperText.text != "You win" && upperText.text != "You lose"{
			checkWinner()
		}
		confirmButton.isHidden = true
		game.switchTurn(controller: self)
	}
	
	@IBAction func confirmChoice(_ sender: Any) {
		var selectedCode = [Int]()
		let turn = game.getTurn() - 1
		// generate selected code as Int array
        for x in 0...3{
            selectedCode.append(color2code(ind: x + (4*turn)))
        }
		// evaluate and draw feedbacks
		drawNewAttempt(code: selectedCode)
    }
    
    func checkWinner(){
		let turn = game.getTurn() - 1
        if upperText.text != "You win" && upperText.text != "You lose"{
            turnLabel.text = "Turn: \(turn+1)"
            if turn < 7{
                for x in 0...3{
                    Buttons[x + (4*turn)].isHidden = false
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
        if p1Black == 4{
            upperText.text = "You win"
            confirmButton.isHidden = true
        }
        if p2Black == 4{
            upperText.text = "You lose"
            confirmButton.isHidden = true
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
        default: print("could not find color: \(Buttons[ind].backgroundColor!)"); return 0
        }
    }

    
    @IBAction func reset(_ sender: Any) {
		game = MasterMind() // create new empty game
        for x in 0...(Buttons.endIndex-1) {
            Buttons[x].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Buttons[x].isEnabled = true
            if x > 3{
                Buttons[x].isHidden = true
            } else {
                Buttons[x].isHidden = false
            }
        }
        for x in 0...(playerEvals.endIndex-1){
            playerEvals[x].text = ""
        }
        turnLabel.text = "Turn: 1"
        upperText.text = "Your turn"
        confirmButton.isHidden = false
    }
    
    //TODO: confirmation pins

    //TODO: scaling buttons

}

