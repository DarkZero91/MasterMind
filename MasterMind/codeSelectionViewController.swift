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
    var code = ["r","r","r","r"]
    var fillButton = 0
    
    @IBOutlet var codeButtons: [UIButton]!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthMultiplier = Double(self.view.frame.size.width) / 375
        heightMultiplier = Double(self.view.frame.size.height) / 667
        scaleView(buttons: allButtons)
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
    
    @IBAction func selectCode(_ sender: Any) {
        performSegue(withIdentifier: "codeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainController = segue.destination as! ViewController
        for x in 0...3{
            code[x] = color2code(ind: x)
        }
        mainController.playerCode = code
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
        /* if (counter == 3){
         counter = 0
         turn += 1
         }
         else{
         counter += 1
         }*/
        //turnLabel.text = "Turn: \(turn)"
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
    
    func color2code(ind:Int) -> String{
        //buttonColor = Buttons[ind].backgroundColor
        switch codeButtons[ind].backgroundColor! {
        case colorButtons[0].backgroundColor!: return colorButtons[0].currentTitle!
        case colorButtons[1].backgroundColor!: return colorButtons[1].currentTitle!
        case colorButtons[2].backgroundColor!: return colorButtons[2].currentTitle!
        case colorButtons[3].backgroundColor!: return colorButtons[3].currentTitle!
        case colorButtons[4].backgroundColor!: return colorButtons[4].currentTitle!
        case colorButtons[5].backgroundColor!: return colorButtons[5].currentTitle!
        default: print("could not find color: \(codeButtons[ind].backgroundColor!)"); return "e"
        }
    }

}
