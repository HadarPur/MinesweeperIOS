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

    let EASY:Int = 0, NORMAL:Int = 1, HARD:Int = 2;
    var mFbStorage : FirebaseStorage?
    var usersData : Array<UserInfo> = Array()
    var users : Array<String> = Array()
    @IBOutlet weak var tableView: UITableView! 
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var eazyBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    let unPressedImage = UIImage(named: "table.png") as UIImage?
    let pressedImage = UIImage(named: "tableopen.png") as UIImage?
    let locationManager = CLLocationManager()

    var currentLat: Double = 0
    var currentLong: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize Firebase
        self.mFbStorage = FirebaseStorage()
        self.eazyBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        self.tableView.isScrollEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.checkGPS()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func hardBtnPressed(_ sender: Any) {
        self.hardBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.normalBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.eazyBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: HARD, callback: {
            self.performQuery()
        })
        self.checkGPS()
    }
    
    @IBAction func normalBtnPressed(_ sender: Any) {
        self.hardBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.normalBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.eazyBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: NORMAL, callback: {
            self.performQuery()
        })
        self.checkGPS()
    }
    
    @IBAction func eazyBtnPressed(_ sender: Any) {
        self.hardBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.normalBtn.setBackgroundImage(unPressedImage, for: UIControl.State.normal)
        self.eazyBtn.setBackgroundImage(pressedImage, for: UIControl.State.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        self.checkGPS()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //When starting a new conversation
    func performQuery() {
        print("Start reading users from DB\n")

        var i: Int = 0
        self.usersData.removeAll()
        self.users.removeAll()
        self.tableView.reloadData()
        
        self.usersData = self.mFbStorage!.getUserInfoArray()
        self.tableView.beginUpdates()

        for user in self.usersData {
            var s: String = ""
            s += "( "
            s += String(i+1)
            s += " ) "
            s += user.toString()
            self.users.append(s)
            print("\n", self.users[i])
            
            self.tableView.insertRows(at: [IndexPath(row: self.users.count-1, section: 0)], with: .automatic)
            i+=1
        }
        self.tableView.endUpdates()
    }
    
    func checkGPS() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = self.locationManager.location else {
                return
            }
            self.currentLat = currentLocation.coordinate.latitude
            self.currentLong = currentLocation.coordinate.longitude
            self.setMyLocationOnTheMap(latitudeUser: self.currentLat, longitudeUser: self.currentLong)
        }
    }
    
    func setLocationOnTheMap(latitudeUser: Double, longitudeUser: Double, titleUser: String) {
        self.setMyLocationOnTheMap(latitudeUser: self.currentLat, longitudeUser: self.currentLong)

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
        
        self.mapView.animate(to: camera)
        marker.map = self.mapView
    }
    
    func setMyLocationOnTheMap(latitudeUser: Double, longitudeUser: Double) {
        self.mapView.clear()
        
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
        
        self.mapView.animate(to: camera)
        marker.map = self.mapView
    }
}

// extension for table view
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "table") as! TableViewCell
        cell.textLabel?.text = row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.setLocationOnTheMap(latitudeUser: self.usersData[indexPath.row].getLatitude(), longitudeUser: self.usersData[indexPath.row].getLongitude(), titleUser: self.usersData[indexPath.row].toString())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// extension for map view
extension RecordsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        self.locationManager.startUpdatingLocation()
    
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
    
}
