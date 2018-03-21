//
//  ViewController.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var fillButton = 0
    var game = MasterMind()
    
    @IBOutlet weak var upperText: UILabel!
    
    @IBOutlet var Buttons: [UIButton]!
    
    @IBOutlet var colorSelection: [UIButton]!
    
    @IBOutlet weak var turnLabel: UILabel!

    @IBOutlet var playerEvals: [UILabel]!
    
    @IBAction func fillColor(_ sender: UIButton) {
        for color in colorSelection{
            color.isHidden = false
        }
        fillButton = Buttons.index(of: sender)!
        print("Button \(fillButton) pressed")
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let currentButton = colorSelection.index(of: sender)!
        Buttons[fillButton].backgroundColor = colorSelection[currentButton].backgroundColor
        /* if (counter == 3){
            counter = 0
            turn += 1
        }
        else{
            counter += 1
        }*/
        //turnLabel.text = "Turn: \(turn)"
        for color in colorSelection{
            color.isHidden = true
        }
    }
    
    @IBAction func confirmChoice(_ sender: Any) {
        var turnDone = true
        for x in 0...3{
            //print("checking button: \(x+(4*turn)) ")
            if Buttons[x + (4*turn)].backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                turnDone = false
                //print("Button \(x+(4*turn)) has not been set")
            }
        }
        if turnDone{
            checkCode()
            

            print("turn is over")
        }
        else{
            print("turn not done yet")
        }
    }
    
    func checkCode(){
        evaluate()
        if upperText.text != "You win"{
            turn += 1
            turnLabel.text = "Turn: \(turn+1)"
            if turn < 8{
                for x in 0...3{
                    Buttons[x + (4*turn)].isHidden = false
                }
            }
            else{
                upperText.text = "You lose"
            }
        }
    }
    
    func evaluate(){
        var code = ["r","r","r","b"] //static code for now
        var white = 0
        var black = 0
        var choice = ["r","r","r","r"]
        
        for x in 0...3{
            Buttons[x + (4*turn)].isEnabled = false
            choice[x] = color2code(ind: x+(4*turn))
            if choice[x] == code[x]{
                black += 1
                playerEvals[turn].text?.append("⚫️")
                code[x] = "done"
                choice[x] = "done"
            }
        }
        //rrrb - rbrr
        //0r0b - 0b0r
        for x in 0...3{
            if choice[x] != "done"{
                if code.contains(choice[x]){
                    white += 1
                    playerEvals[turn].text?.append("⚪️")
                    code[code.index(of: choice[x])!] = "done"
                    choice[x] = "done"
                }
            }
        }
        
        print("Black: \(black) White: \(white)")
        if black == 4{
            upperText.text = "You win"
        }
        
    }
    
    func color2code(ind:Int) -> String{
        //buttonColor = Buttons[ind].backgroundColor
        switch Buttons[ind].backgroundColor! {
        case colorSelection[0].backgroundColor!: return "r"
        case colorSelection[1].backgroundColor!: return "y"
        case colorSelection[2].backgroundColor!: return "g"
        case colorSelection[3].backgroundColor!: return "b"
        case colorSelection[4].backgroundColor!: return "p"
        case colorSelection[5].backgroundColor!: return "w"
        default: print("could not find color: \(Buttons[ind].backgroundColor!)"); return "e"
        }
    }

    
    @IBAction func reset(_ sender: Any) {
        turn = 0
        for x in 0...(Buttons.endIndex-1){
            Buttons[x].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Buttons[x].isEnabled = true
            if x > 3{
                Buttons[x].isHidden = true
            }
            else{
                Buttons[x].isHidden = false
            }
        }
        for x in 0...(playerEvals.endIndex-1){
            playerEvals[x].text = ""
        }
        turnLabel.text = "Turn: 1"
        upperText.text = "Your turn"
    }
    
    //TODO: confirmation pins

    //TODO: scaling buttons

}

