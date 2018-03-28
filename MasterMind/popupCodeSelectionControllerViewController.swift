//
//  popupCodeSelectionControllerViewController.swift
//  MasterMind
//
//  Created by R. Elderman on 28/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import UIKit

class popupCodeSelectionControllerViewController: UIViewController {

	var widthMultiplier = 0.0
	var heightMultiplier = 0.0
	@IBOutlet weak var instructionField: UILabel!
	@IBOutlet weak var returnButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		widthMultiplier = Double(self.view.frame.size.width) / 375
		heightMultiplier = Double(self.view.frame.size.height) / 667
		scaleView(buttons: [returnButton])
		scaleView(labels: [instructionField])
		// Do any additional setup after loading the view.
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
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func popupDone(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
}
