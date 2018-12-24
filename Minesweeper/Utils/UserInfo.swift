//
//  UserInfo.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/11/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//


class UserInfo {
    let EASY: Int = 0, NORMAL: Int = 1, HARD: Int = 2
    var mKey: Int!
    var mName: String!
    var mLatitude: Double!
    var mLongitude: Double!
    var mPoints: Int!
    var mLevel: String!
    
    func UserInfo(key: Int,name: String,latitude: Double,longitude: Double ,points: Int, level: Int){
        self.mKey=key
        self.mName=name
        self.mLatitude=latitude
        self.mLongitude=longitude
        self.mPoints=points
        
        switch (level){
        case EASY:
            self.mLevel="Easy"
            break
        case NORMAL:
            self.mLevel="Medium"
            break
        case HARD:
            self.mLevel="Hard"
            break
        default:
            break
        }
    }
    
    func getKey() -> Int {
        return self.mKey
    }
    
    func getName() -> String {
        return self.mName
    }
    
    func getLatitude() -> Double {
        return self.mLatitude
    }
    
    func getLongitude() -> Double {
        return self.mLongitude
    }
    
    func getPoints() -> Int {
        return self.mPoints
    }
    
    func getLevel() -> String {
        return self.mLevel
    }
    
    func setKey(key: Int) {
        self.mKey = key
        
    }
    
    func toString() -> String{
        let objectString : String = "Name: \(self.mName ?? ""), TIme: \(self.mPoints ?? 0) sec"
        return objectString
    }
}
