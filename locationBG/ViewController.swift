//
//  ViewController.swift
//  locationBG
//
//  Created by Vipin on 18/01/22.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let center = UNUserNotificationCenter.current()
    
    private lazy var locationManager: CLLocationManager = {
      let manager = CLLocationManager()
      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.delegate = self
      manager.requestAlwaysAuthorization()
      manager.allowsBackgroundLocationUpdates = true
      manager.pausesLocationUpdatesAutomatically = false
      return manager
    }()
    
    
    override func viewDidLoad() {
        
        locationManager.startUpdatingLocation()
        
        //todo ask permision for local notification
        center.requestAuthorization(options: [.alert,.sound]) { result, err in
            if err == nil {
                if result {
                    print("Granted")
                }else{
                    print("Permision denied")
                }
            }else{
                print("Error--- \(err!.localizedDescription)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func alertForUpdatingLocation(_ locationData:String){
       
        //Create content
        let content = UNMutableNotificationContent()
        content.title = "Location Updated"
        content.body = locationData
        
        //create request
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        center.add(req) { err in
            if (err != nil) {
                print(err!.localizedDescription)
            }else{
                print("notification fired")
            }
        }
    }
  }



  // MARK: - CLLocationManagerDelegate
  extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
    guard let mostRecentLocation = locations.last else {
        return
      }
      
      if UIApplication.shared.applicationState == .active {
        print("app is in foreground and last updated location is: \(mostRecentLocation)")
      } else {
        print("App is backgrounded. New location is %@", mostRecentLocation)
       
          alertForUpdatingLocation("App is backgrounded. New location is, \(mostRecentLocation)")
      }
    }
    
  }
