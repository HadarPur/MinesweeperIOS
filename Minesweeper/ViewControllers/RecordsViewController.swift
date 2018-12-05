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

class RecordsViewController: UIViewController, CallData {

    let EASY:Int = 0, NORMAL:Int = 1, HARD:Int = 2
    let mLocationManager = CLLocationManager()

    var mFbStorage : FirebaseStorage?
    var mUsersData : Array<UserInfo> = Array()
    var mUsers : Array<String> = Array()
    @IBOutlet weak var mTableView: UITableView! 
    
    @IBOutlet weak var mMapView: GMSMapView!
    @IBOutlet weak var mEazyBtn: UIButton!
    @IBOutlet weak var mNormalBtn: UIButton!
    @IBOutlet weak var mHardBtn: UIButton!
    
    let unPressedImage = UIImage(named: "table.png") as UIImage?
    let pressedImage = UIImage(named: "tableopen.png") as UIImage?

    var mCurrentLat: Double = 0
    var mCurrentLong: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize Firebase
        self.mFbStorage = FirebaseStorage()
        self.mEazyBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        self.mTableView.isScrollEnabled = true
        
        self.mLocationManager.delegate = self
        self.mLocationManager.requestWhenInUseAuthorization()
        checkGPS()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func hardBtnPressed(_ sender: Any) {
        self.mHardBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mNormalBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mEazyBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: HARD, callback: {
            self.performQuery()
        })
        checkGPS()
    }
    
    @IBAction func normalBtnPressed(_ sender: Any) {
        self.mHardBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mNormalBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mEazyBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: NORMAL, callback: {
            self.performQuery()
        })
        checkGPS()
    }
    
    @IBAction func eazyBtnPressed(_ sender: Any) {
        self.mHardBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mNormalBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mEazyBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        checkGPS()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //When starting a new conversation
    func performQuery() {
        print("Start reading users from DB\n")

        var i: Int = 0
        self.mUsersData.removeAll()
        self.mUsers.removeAll()
        self.mTableView.reloadData()
        
        self.mUsersData = self.mFbStorage!.getUserInfoArray()
        self.mTableView.beginUpdates()

        for user in self.mUsersData {
            var s: String = ""
            s += "( "
            s += String(i+1)
            s += " ) "
            s += user.toString()
            self.mUsers.append(s)
            print("\n", self.mUsers[i])
            
            self.mTableView.insertRows(at: [IndexPath(row: self.mUsers.count-1, section: 0)], with: .automatic)
            i+=1
        }
        self.mTableView.endUpdates()
    }
    
    func checkGPS() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = self.mLocationManager.location else {
                return
            }
            self.mCurrentLat = currentLocation.coordinate.latitude
            self.mCurrentLong = currentLocation.coordinate.longitude
            setMyLocationOnTheMap(latitudeUser: self.mCurrentLat, longitudeUser: self.mCurrentLong)
        }
    }
    
    func setLocationOnTheMap(latitudeUser: Double, longitudeUser: Double, titleUser: String) {
        self.setMyLocationOnTheMap(latitudeUser: self.mCurrentLat, longitudeUser: self.mCurrentLong)

        let latitude = latitudeUser
        let longitude = longitudeUser
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        let userLocetion = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:userLocetion.latitude, longitude: userLocetion.longitude)
        let marker = GMSMarker(position: userLocetion)
        
        marker.iconView = UIImageView(image: UIImage(named: "mark.png"))
        marker.title = titleUser
        
        
        geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            else {
                let locationStreet = placemarks?[0]
                let locName: String = locationStreet?.name ?? "null"
                let locLocality: String = locationStreet?.locality ?? "null"
                marker.snippet = locName+", "+locLocality
            }
        })
        
        self.mMapView.animate(to: camera)
        marker.map = self.mMapView
    }
    
    func setMyLocationOnTheMap(latitudeUser: Double, longitudeUser: Double) {
        self.mMapView.clear()
        
        let latitude = latitudeUser
        let longitude = longitudeUser
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        let userLocetion = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:userLocetion.latitude, longitude: userLocetion.longitude)
        let marker = GMSMarker(position: userLocetion)
        
        if (latitude != 0 && longitude != 0) {
            geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                else {
                    marker.title = "Current Position"
                    let locationStreet = placemarks?[0]
                    let locName: String = locationStreet?.name ?? "null"
                    let locLocality: String = locationStreet?.locality ?? "null"
                    marker.snippet = locName+", "+locLocality
                }
            })
        }
        else{
            marker.title = "No Position to show"
        }
        
        self.mMapView.animate(to: camera)
        marker.map = self.mMapView
    }
}

// extension for table view
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = mUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "table") as! TableViewCell
        cell.textLabel?.text = row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.setLocationOnTheMap(latitudeUser: self.mUsersData[indexPath.row].getLatitude(), longitudeUser: self.mUsersData[indexPath.row].getLongitude(), titleUser: self.mUsersData[indexPath.row].toString())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// extension for map view
extension RecordsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        self.mLocationManager.startUpdatingLocation()
    
        self.mMapView.isMyLocationEnabled = true
        self.mMapView.settings.myLocationButton = true
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mLocationManager.stopUpdatingLocation()
    }
    
}
