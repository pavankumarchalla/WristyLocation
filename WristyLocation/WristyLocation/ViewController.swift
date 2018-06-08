//
//  ViewController.swift
//  WristyLocation
//
//  Created by Pavan Kumar C on 08/06/18.
//  Copyright © 2018 pavan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var locationTableView: UITableView!
  
  var locationManager: CLLocationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
    locationManager.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK:- TableView delegate and datasource methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = "Hello world"
    return cell
  }
  
  //MARK:- IBAction methods
  
  @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
    
  }
  
  @IBAction func addClicked(_ sender: UIBarButtonItem) {
    
  }
  
  //MARK:- CLLocationManager delegate methods
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
  }
}

