//
//  Clue.swift
//  MasterMind
//
//  Created by R. Elderman on 06/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//
import Foundation

class Clue: NSObject {
	
	var colorCode:[Int]
	var whitePoints:Int
	var blackPoints:Int
	var myWhitePoints:Int
	var myBlackPoints:Int
	
	
	init(colorCode:[Int], whitePoints:Int, blackPoints:Int, myWhitePoints:Int, myBlackPoints:Int) {
		self.colorCode = colorCode
		self.whitePoints = whitePoints
		self.blackPoints = blackPoints
		self.myBlackPoints = myBlackPoints
		self.myWhitePoints = myWhitePoints
	}
	
	func getColorCode() -> [Int] {
		return colorCode
	}
	
	func getWhitePoints() -> Int {
		return whitePoints
	}
	
	func getBlackPoints() -> Int {
		return blackPoints
	}
	
	func getMyWhitePoints() -> Int {
		return myWhitePoints
	}
	
	func getMyBlackPoints() -> Int {
		return myBlackPoints
	}
}

