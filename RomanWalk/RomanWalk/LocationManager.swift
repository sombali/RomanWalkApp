//
//  LocationManager.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 07..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    var simulatorLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 47.517118)!, longitude: CLLocationDegrees(exactly: 19.06765)!)
   
    var lastLocation: CLLocation?
    private var timeoutTimer: Timer?
    private var locationUpdated: (() -> Void)!
    private var locationManager: CLLocationManager!
    
    func startLocationManager(updated: @escaping () -> Void) {

      locationUpdated = updated

      locationManager = CLLocationManager()
      locationManager.requestWhenInUseAuthorization()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

      timeoutTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(stopLocationManager), userInfo: nil, repeats: false)

      locationManager.startUpdatingLocation()
    }
    
    @objc func stopLocationManager() {
      if let timer = timeoutTimer {
        timer.invalidate()
      }

      locationManager.stopUpdatingLocation()
      locationUpdated()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let newLocation = locations.last else {
        return
      }

      if -newLocation.timestamp.timeIntervalSinceNow > 5.0 {
        return
      }

      if newLocation.horizontalAccuracy < 0 {
        return
      }

      if lastLocation == nil || lastLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
        lastLocation = newLocation

        if newLocation.horizontalAccuracy <= manager.desiredAccuracy {
          stopLocationManager()
        }
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      stopLocationManager()
      print(error.localizedDescription)
    }
}
