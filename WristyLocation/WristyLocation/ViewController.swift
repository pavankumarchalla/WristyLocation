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
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var locationTableView: UITableView!
  
  var locationManager: CLLocationManager!
  var moc:NSManagedObjectContext!
  var locationArray = [Location]()
  var firstLoad = true
  var currentLocation: CLLocation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
    locationManager.delegate = self
    moc = SwiftCoreDataHelper.managedObjectContext()
    
    let code = CLLocationManager.authorizationStatus()
    if code == CLAuthorizationStatus.notDetermined {
      if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil {
        locationManager.requestAlwaysAuthorization()
      } else if code == CLAuthorizationStatus.denied || code == CLAuthorizationStatus.restricted {
        print("Location Permission denied")
      }
    } else {
      locationManager.startUpdatingLocation()
    }
    
    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK:- TableView delegate and datasource methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = locationArray[indexPath.row].title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let locationObj = locationArray[indexPath.row]
    let coordinates = NSKeyedUnarchiver.unarchiveObject(with: locationObj.coordinates as! Data) as! CLLocation
    displayLocation(location: coordinates)
    
  }
  
  //MARK:- IBAction methods
  
  @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
    locationManager.startUpdatingLocation()
    displayLocation()
  }
  
  @IBAction func addClicked(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Where are you?", message: "Enter a location title", preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) in
      let textField = alert.textFields?.first as! UITextField
      if textField.text != "" {
        let locationObject = SwiftCoreDataHelper.insertManagedObjectContext(className: NSStringFromClass(Location.self), managedObjectContext: self.moc) as! Location
        locationObject.title = textField.text
        let location = CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        locationObject.coordinates = NSKeyedArchiver.archivedData(withRootObject: location) as NSData
        SwiftCoreDataHelper.saveManagedObjectContext(managedObjectContext: self.moc)
        self.loadData()
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  //MARK:- CLLocationManager delegate methods
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status != CLAuthorizationStatus.restricted || status != CLAuthorizationStatus.denied {
      displayLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = location
      displayLocation()
    }
  }
  
  //MARK:- Custom funcs
  
  func loadData() {
    locationArray = SwiftCoreDataHelper.fetchEntities(className: NSStringFromClass(Location.self), predicate: nil, sortDescriptor: nil, managedObjectContext: moc) as! [Location]
    locationTableView.reloadData()
  }
  
  func displayLocation() {
    if currentLocation != nil {
      mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.05, 0.05)), animated: true)
    }
  }
  
  func displayLocation(location: CLLocation) {
    mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), MKCoordinateSpanMake(0.05, 0.05)), animated: true)
    
    let locationPin = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let annotation = MKPointAnnotation()
    annotation.coordinate = locationPin
    mapView.addAnnotation(annotation)
    mapView.showAnnotations([annotation], animated: true)
  }
  
}

