//
//  RecordsViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 21/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class RecordsViewController: UIViewController, CallData, UITableViewDelegate, UITableViewDataSource {

    let EASY:Int = 0, NORMAL:Int = 1, HARD:Int = 2;
    var mFbStorage : FirebaseStorage?
    var usersData : Array<UserInfo> = Array()
    var users : Array<String> = Array()
    @IBOutlet weak var tableView: UITableView! 
    
    @IBOutlet weak var mapViewContainer: MKMapView!
    @IBOutlet weak var eazyBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    let unPressedImage = UIImage(named: "table.png") as UIImage?
    let pressedImage = UIImage(named: "tableopen.png") as UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize Firebase
        self.mFbStorage = FirebaseStorage()
        eazyBtn.setBackgroundImage(pressedImage, for: UIControlState.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        self.tableView.isScrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        GMSServices.provideAPIKey("AIzaSyA-NLDBLCWRcP1OWgFJzFrNJefGnMo0aj0")
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 10)
        let mapView = GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
        self.mapViewContainer?.addSubview(mapView)
    }
    
    @IBAction func hardBtnPressed(_ sender: Any) {
        hardBtn.setBackgroundImage(pressedImage, for: UIControlState.normal)
        normalBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        eazyBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        self.mFbStorage!.readResults(level: HARD, callback: {
            self.performQuery()
        })
    }
    
    @IBAction func normalBtnPressed(_ sender: Any) {
        hardBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        normalBtn.setBackgroundImage(pressedImage, for: UIControlState.normal)
        eazyBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        self.mFbStorage!.readResults(level: NORMAL, callback: {
            self.performQuery()
        })
    }
    
    @IBAction func eazyBtnPressed(_ sender: Any) {
        hardBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        normalBtn.setBackgroundImage(unPressedImage, for: UIControlState.normal)
        eazyBtn.setBackgroundImage(pressedImage, for: UIControlState.normal)
        

        
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //When starting a new conversation
    func performQuery() {
        
        var i: Int = 0
        self.usersData.removeAll()
        self.users.removeAll()
        self.tableView.reloadData()
        
        self.usersData = self.mFbStorage!.getUserInfoArray()
        for user in self.usersData {
            var s: String = ""
            s += "( "
            s += String(i+1)
            s += " ) "
            s += user.toString()
            self.users.append(s)
            print("s: \n", self.users[i])
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.users.count-1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            
            i+=1
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "table") as! TableViewCell
        cell.textLabel?.text = row
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
