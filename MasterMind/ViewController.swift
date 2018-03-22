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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthMultiplier = Double(self.view.frame.size.width) / 375
        heightMultiplier = Double(self.view.frame.size.height) / 667
        scaleView(labels: allLabels)
        scaleView(labels: playerEvals)
        scaleView(labels: opponentEvals)
        scaleView(buttons: Buttons)
        scaleView(buttons: colorSelection)
        scaleView(buttons: allButtons)
/*        for button in Buttons{
            button.frame.size.width = button.frame.width * CGFloat(widthMultiplier)
            button.frame.size.height = button.frame.height * CGFloat(heightMultiplier)
            button.frame.origin = CGPoint(x: button.frame.origin.x * CGFloat(widthMultiplier), y: button.frame.origin.y * CGFloat(heightMultiplier))
        }
        upperText.frame.size.width = upperText.frame.width * CGFloat(widthMultiplier)
        upperText.frame.size.height = upperText.frame.height * CGFloat(heightMultiplier)
        upperText.frame.origin = CGPoint(x: upperText.frame.origin.x * CGFloat(widthMultiplier), y: upperText.frame.origin.y * CGFloat(heightMultiplier))*/
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
    
    //width: 375.0 height: 667.0
    var fillButton = 0
    var turn = 0
    
    @IBOutlet var allLabels: [UILabel]!
    
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet weak var upperText: UILabel!
    
    @IBOutlet var Buttons: [UIButton]!
    
    @IBOutlet var colorSelection: [UIButton]!
    
    @IBOutlet weak var turnLabel: UILabel!

    @IBOutlet var opponentEvals: [UILabel]!
    
    @IBOutlet var playerEvals: [UILabel]!
    
    @IBAction func fillColor(_ sender: UIButton) {
        for color in colorSelection{
            color.isHidden = false
        }
        fillButton = Buttons.index(of: sender)!
        print("Button \(fillButton): \(Buttons[fillButton].frame.size.width) x \(Buttons[fillButton].frame.size.height)")
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
        var playerCode = ["b","y","g","w"]
        var pwhite = 0
        var pblack = 0
        var owhite = 0
        var oblack = 0
        var choice = ["r","r","r","r"]
        
        //opponentEval
        for x in 0...3{
            Buttons[x + (4*turn)].isEnabled = false
            choice[x] = color2code(ind: x+(4*turn))
            if choice[x] == code[x]{
                pblack += 1
                playerEvals[turn].text?.append("⚫️")
                code[x] = "done"
                choice[x] = "done"
            }
        }

        for x in 0...3{
            if choice[x] != "done"{
                if code.contains(choice[x]){
                    pwhite += 1
                    playerEvals[turn].text?.append("⚪️")
                    code[code.index(of: choice[x])!] = "done"
                    choice[x] = "done"
                }
            }
        }
        
        //playerEval
        for x in 0...3{
            Buttons[x + (4*turn)].isEnabled = false
            choice[x] = color2code(ind: x+(4*turn))
            if choice[x] == playerCode[x]{
                oblack += 1
                opponentEvals[turn].text?.append("⚫️")
                playerCode[x] = "done"
                choice[x] = "done"
            }
        }
        
        for x in 0...3{
            if choice[x] != "done"{
                if playerCode.contains(choice[x]){
                    owhite += 1
                    opponentEvals[turn].text?.append("⚪️")
                    playerCode[playerCode.index(of: choice[x])!] = "done"
                    choice[x] = "done"
                }
            }
        }
        
        //eval
        print("Black: \(pblack) White: \(pwhite)")
        if pblack == 4{
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

