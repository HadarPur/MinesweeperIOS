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
    let locationManager: CLLocationManager? = nil
    var marker: GMSMarker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize Firebase
        self.mFbStorage = FirebaseStorage()
        eazyBtn.setBackgroundImage(pressedImage, for: UIControlState.normal)
        self.mFbStorage!.readResults(level: EASY, callback: {
            self.performQuery()
        })
        self.tableView.isScrollEnabled = true
        self.locationManager?.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mapView.clear()
        
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        let latitude = self.usersData[indexPath.row].getLatitude()
        let longitude = self.usersData[indexPath.row].getLongitude()
        
        print("latitude: \(latitude)")
        print("longitude: \(longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        self.mapView.animate(to: camera)

        let currentLocetion = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.marker = GMSMarker(position: currentLocetion)
        self.marker.iconView = UIImageView(image: UIImage(named: "mark.png"))
        self.marker.title = self.usersData[indexPath.row].toString()
        print("users: \(self.usersData[indexPath.row].toString())")

        let geocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:currentLocetion.latitude, longitude: currentLocetion.longitude)
        geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            else
            {
                let locationStreet = placemarks?[0]
                self.marker.snippet = (locationStreet?.name)!+", "+(locationStreet?.locality)!
            }
        })
        self.marker.map = self.mapView
        
    }
}

// extension for map view
extension RecordsViewController: CLLocationManagerDelegate {
    
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
    return
    }
    self.locationManager?.startUpdatingLocation()
    
    self.mapView.isMyLocationEnabled = true
    self.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.locationManager?.stopUpdatingLocation()
    }
}
