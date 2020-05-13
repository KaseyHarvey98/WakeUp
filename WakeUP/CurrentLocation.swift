//
//  CurrentLocation.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/11/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocation: UITableViewController, CLLocationManagerDelegate {

    var location: CLLocation?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?

    @IBOutlet weak var addressLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()

        // Do any additional setup after loading the view.
    }
    
    let locationManager = CLLocationManager()
    
    @IBAction func getLocation() {

        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
          showLocationServicesDeniedAlert()
        return
        }
        if authStatus == .notDetermined {locationManager.requestWhenInUseAuthorization()
        return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy =
                        kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK:- Helper Methods
    func showLocationServicesDeniedAlert() {
      let alert = UIAlertController(
        title: "Location Services Disabled",
        message: "Please enable location services for this app in Settings.",
        preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default,
                               handler: nil)
    present(alert, animated: true, completion: nil)
      alert.addAction(okAction)
    }
    func string(from placemark: CLPlacemark) -> String {
    var line1 = ""
      if let s = placemark.postalCode {
    line1 += s }
        return line1 + "\n"
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager,
            didFailWithError error: Error) {
      print("didFailWithError \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]) {
      let newLocation = locations.last!
      print("didUpdateLocations \(newLocation)")
      location = newLocation
    if !performingReverseGeocoding {
          print("*** Going to geocode")
          performingReverseGeocoding = true
        geocoder.reverseGeocodeLocation(newLocation,completionHandler: {
        placemarks, error in
        self.lastGeocodingError = error
        if error == nil, let p = placemarks, !p.isEmpty {
          self.placemark = p.last!
        } else {
          self.placemark = nil
        }
        self.performingReverseGeocoding = false
            self.updateLabels()
        })
        }
    }
    
    func updateLabels() {
        if location != nil {
            if let placemark = placemark { addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
              addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
              addressLabel.text = "Error Finding Address"
            } else { addressLabel.text = "No Address Found"
            }
         } else {
            addressLabel.text = ""
        }
    }
}
