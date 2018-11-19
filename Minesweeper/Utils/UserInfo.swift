//
//  UserInfo.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/11/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//


class UserInfo {
    let EASY: Int = 0, NORMAL: Int = 1, HARD: Int = 2
    var key: Int!
    var name: String!
    var latitude: Double!
    var longitude: Double!
    var points: Int!
    var level: String!
    
    func UserInfo(key: Int,name: String,latitude: Double,longitude: Double ,points: Int, level: Int){
        self.key=key
        self.name=name
        self.latitude=latitude
        self.longitude=longitude
        self.points=points
        
        switch (level){
        case EASY:
            self.level="Easy"
            break
        case NORMAL:
            self.level="Medium"
            break
        case HARD:
            self.level="Hard"
            break
        default:
            break
        }
    }
    
    func getKey() -> Int {
        return self.key
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }
    
    func getPoints() -> Int {
        return self.points
    }
    
    func getLevel() -> String {
        return self.level
    }
    
    func setKey(key: Int) {
        self.key = key
        
    }
    
    func toString() -> String{
        var objectString : String = " "
        objectString += " Name: "
        objectString += self.name
        objectString += "  , Time: "
        objectString += String(self.points)
        objectString += " sec"
        return objectString;
    }
}
