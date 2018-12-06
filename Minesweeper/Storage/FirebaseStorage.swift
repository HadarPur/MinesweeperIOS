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
    var mReaded: UserInfo!
    var myRefEasy: DatabaseReference!
    var myRefMedium: DatabaseReference!
    var myRefHard: DatabaseReference!
    var mEasyUsers : Array<UserInfo> = Array()
    var mNormalUsers : Array<UserInfo> = Array()
    var mHardUsers : Array<UserInfo> = Array()
    var mUsers : Array<UserInfo> = Array()

    override init() {
        self.myRefEasy = Database.database().reference(withPath: "EasyRecords")
        self.myRefMedium = Database.database().reference(withPath: "MediumRecords")
        self.myRefHard = Database.database().reference(withPath: "HardRecords")
    }
    
    //read from firebase
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
    
    // replace user in firebase
    func replaceUser(user: UserInfo,level: Int, users: Array<UserInfo>) {
        let key: Int = users[users.count-1].getKey()
        let keyStr: String = " "+String(key)
        user.setKey(key: key)
        switch level {
            case EASY:
                self.myRefEasy.child(keyStr).setValue(user)
                break
            case NORMAL:
                self.myRefMedium.child(keyStr).setValue(user)
                break
            case HARD:
                self.myRefHard.child(keyStr).setValue(user)
                break
            default:
                break
        }
    }
    
    // write new user in firebase
    func writeUser(user: UserInfo,level: Int) {
        let keyStr: String = " "+String(user.getKey())
        switch level {
        case EASY:
            self.myRefEasy.child(keyStr).setValue(user)
            break
        case NORMAL:
            self.myRefMedium.child(keyStr).setValue(user)
            break
        case HARD:
            self.myRefHard.child(keyStr).setValue(user)
            break
        default:
            break
        }
    }
    
    //firebase event
    func callingEvent(myRef: DatabaseReference, level: Int, callback: @escaping () -> ()) {
        self.mEasyUsers.removeAll()
        self.mNormalUsers.removeAll()
        self.mHardUsers.removeAll()

        myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let iterator = snapshot.children
            while let child = iterator.nextObject() as? DataSnapshot {
                let userDic = child.value as! [String: Any]
                let key = userDic["key"] as! Int
                let name = userDic["name"] as! String
                let latitude = userDic["latitude"] as! Double
                let longitude = userDic["longitude"] as! Double
                let points = userDic["points"] as! Int
                self.mReaded = UserInfo()
                self.mReaded.UserInfo(key: key,name: name,latitude: latitude,longitude: longitude,points: points,level: level)
                
                switch level {
                case self.EASY:
                    self.mEasyUsers.append(self.mReaded)
                    break
                case self.NORMAL:
                    self.mNormalUsers.append(self.mReaded)
                    break
                case self.HARD:
                    self.mHardUsers.append(self.mReaded)
                    break
                default:
                    break
                }
            }
            
            switch level {
            case self.EASY:
                self.mEasyUsers.sort(by: self.sorterForArray)
                self.mUsers = self.mEasyUsers
                callback()
                break;
            case self.NORMAL:
                self.mNormalUsers.sort(by: self.sorterForArray)
                self.mUsers = self.mNormalUsers
                callback()
                break;
            case self.HARD:
                self.mHardUsers.sort(by: self.sorterForArray)
                self.mUsers = self.mHardUsers
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
        return self.mUsers
    }
}
