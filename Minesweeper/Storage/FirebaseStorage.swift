//
//  FirebaseStorage.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/11/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class FirebaseStorage: NSObject {
    let EASY:Int = 0, NORMAL:Int = 1, HARD:Int = 2;
    var readed: UserInfo!
    var myRefEasy: DatabaseReference!
    var myRefMedium: DatabaseReference!
    var myRefHard: DatabaseReference!
    var easyUsers : Array<UserInfo> = Array()
    var normalUsers : Array<UserInfo> = Array()
    var hardUsers : Array<UserInfo> = Array()
    var users : Array<UserInfo> = Array()


    override init() {
        self.myRefEasy = Database.database().reference(withPath: "EasyRecords")
        self.myRefMedium = Database.database().reference(withPath: "MediumRecords")
        self.myRefHard = Database.database().reference(withPath: "HardRecords")
    }
    
    //read from fire base
    func readResults(level: Int, callback: @escaping () -> ()) {
        switch level {
        case EASY:
            callingEvent(myRef: myRefEasy, level: level, callback: callback)
            break
        case NORMAL:
            callingEvent(myRef: myRefMedium, level: level, callback: callback)
            break
        case HARD:
            callingEvent(myRef: myRefHard, level: level, callback: callback)
            break
        default:
            break
        }
    }
    
    //fire base event
    func callingEvent(myRef: DatabaseReference, level: Int, callback: @escaping () -> ()) {
        self.easyUsers.removeAll()
        self.normalUsers.removeAll()
        self.hardUsers.removeAll()

        myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let iterator = snapshot.children
            while let child = iterator.nextObject() as? DataSnapshot {
                let userDic = child.value as! [String: Any]
                let key = userDic["key"] as! Int
                let name = userDic["name"] as! String
                let latitude = userDic["latitude"] as! Double
                let longitude = userDic["longitude"] as! Double
                let points = userDic["points"] as! Int
                self.readed = UserInfo()
                self.readed.UserInfo(key: key,name: name,latitude: latitude,longitude: longitude,points: points,level: level)
                
                switch level {
                case self.EASY:
                    self.easyUsers.append(self.readed)
                    break
                case self.NORMAL:
                    self.normalUsers.append(self.readed)
                    break
                case self.HARD:
                    self.hardUsers.append(self.readed)
                    break
                default:
                    break
                }
            }
            
            switch level {
            case self.EASY:
                self.easyUsers.sort(by: self.sorterForArray)
                self.users = self.easyUsers
                callback()
                break;
            case self.NORMAL:
                self.normalUsers.sort(by: self.sorterForArray)
                self.users = self.normalUsers
                callback()
                break;
            case self.HARD:
                self.hardUsers.sort(by: self.sorterForArray)
                self.users = self.hardUsers
                callback()
                break;
            default:
                break
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sorterForArray(this: UserInfo, that: UserInfo) -> Bool {
        return this.getPoints() < that.getPoints()
    }
    
    func getUserInfoArray() -> Array<UserInfo> {
        return self.users
    }
}
