//
//  codeSelectionViewController.swift
//  MasterMind
//
//  Created by S.K. Muller on 22/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import UIKit

class codeSelectionViewController: UIViewController {

    var widthMultiplier = 0.0
    var heightMultiplier = 0.0
    var code = [0,0,0,0]
    var fillButton = 0
	var totGames = 0
	var totAttempts = 0
    
    @IBOutlet var codeButtons: [UIButton]!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var allLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthMultiplier = Double(self.view.frame.size.width) / 375
        heightMultiplier = Double(self.view.frame.size.height) / 667
        scaleView(buttons: allButtons)
        scaleView(labels: allLabels)
        circleButtons(buttons: codeButtons)
        circleButtons(buttons: colorButtons)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func selectCode(_ sender: Any) {
        performSegue(withIdentifier: "codeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeSegue" {
			
            let mainController = segue.destination as! ViewController
            for x in 0...3 {
                code[x] = color2code(ind: x)
            }
			//maybe TODO very ugly here, if possible move to viewcontroller
            mainController.game.player2.code = code
			mainController.totAttempts = self.totAttempts
			mainController.totGames = self.totGames
        }
    }
    
    @IBAction func fillColor(_ sender: UIButton) {
        for color in colorButtons{
            color.isHidden = false
        }
        fillButton = codeButtons.index(of: sender)!
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let currentButton = colorButtons.index(of: sender)!
        codeButtons[fillButton].backgroundColor = colorButtons[currentButton].backgroundColor
        for color in colorButtons{
            color.isHidden = true
        }
        let validity = checkValidity()
        if (validity){
            confirmButton.isHidden = false
        }
        
    }
    
    func checkValidity() -> Bool{
        for button in codeButtons{
            if button.backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                return false
            }
        }
        return true
    }
    
    func color2code(ind:Int) -> Int{
        //buttonColor = Buttons[ind].backgroundColor
        switch codeButtons[ind].backgroundColor! {
        case colorButtons[0].backgroundColor!: return 1
        case colorButtons[1].backgroundColor!: return 2
        case colorButtons[2].backgroundColor!: return 3
        case colorButtons[3].backgroundColor!: return 4
        case colorButtons[4].backgroundColor!: return 5
        case colorButtons[5].backgroundColor!: return 6
        default: print("could not find color: \(codeButtons[ind].backgroundColor!)"); return 0
        }
    }

    

}
