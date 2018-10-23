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

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var mapViewContainer: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    
        GMSServices.provideAPIKey("AIzaSyA-NLDBLCWRcP1OWgFJzFrNJefGnMo0aj0")
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 10)
        let mapView = GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
        self.mapViewContainer?.addSubview(mapView)
    }
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)

    }
}
