//
//  Clue.swift
//  MasterMind
//
//  Created by R. Elderman on 06/03/2018.
//  Copyright © 2018 Team4. All rights reserved.
//
import Foundation

class Clue: NSObject {

    var colorCode:[Int8]
    var whitePoints:Int8
    var blackPoints:Int8
    var myWhitePoints:Int8
    var myBlackPoints:Int8

    
    init(colorCode:[Int8], whitePoints:Int8, blackPoints:Int8, myWhitePoints:Int8, myBlackPoints:Int8) {
        self.colorCode = colorCode
        self.whitePoints = whitePoints
        self.blackPoints = blackPoints
        self.myBlackPoints = myBlackPoints
        self.myWhitePoints = myWhitePoints
    }
    
    func getColorCode() -> [Int8] {
        return colorCode
    }

    func getWhitePoints() -> Int8 {
        return whitePoints
    }

    func getBlackPoints() -> Int8 {
        return blackPoints
    }

    func getMyWhitePoints() -> Int8 {
        return myWhitePoints
    }

    func getMyBlackPoints() -> Int8 {
        return myBlackPoints
    }
}
