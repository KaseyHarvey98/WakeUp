//
//  Morning.swift
//  WakeUP
//
//  Created by Kasey Harvey on 5/12/20.
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Morning : UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    var saveZipcode = ""
    var finalName = ""
    @IBOutlet weak var weatherLabel: UILabel!
    
    let locationManager = CLLocationManager() // this object will give us the GPS Coordinates
    var location: CLLocation? // this stores the user's current location and changes as new GPS coordinates come in
    var updatingLocation = false // Checking if the app is trying to get GPS coordinates
    var lastLocationError: Error?
    
    // GeoCoding
    let geocoder = CLGeocoder() // this object will perform the geocoding
    var placemark: CLPlacemark? // this object will contain the address results
    var performingReverseGeoCoding = false
    var lastGeoCodingError: Error?
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        updateLabels()
    }
    
    func getLocation(){
        // Asking for Permissin
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted{
            showLocationDeniedAlert()
            return
        }
        
        if updatingLocation{
            stopLocationManager()
        }else{
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeoCodingError = nil
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Setting the accuracy
            locationManager.startUpdatingLocation() // Start obtaining the GPS coordinates
            updatingLocation = true
        }
    }
    
    func showLocationDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        
        lastLocationError = error
        stopLocationManager()
    }
    
    func stopLocationManager(){
        if updatingLocation{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = self
            updatingLocation = false
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let newLocation = locations.last{
//            // If new location was determined later than 5 seconds ago, ignore it
//            if newLocation.timestamp.timeIntervalSinceNow < -5{
//                return
//            }
//
//            // If horizontal accuracy is less than zero, ignore it
//            if newLocation.horizontalAccuracy < 0{
//                return
//            }
//
//            // Calculating the distance between the new reading and the previous reading
//            var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
//            if let location = location{
//                distance = newLocation.distance(from: location)
//            }
//
//            // 3. if no location was set yet or new location is more accurate (a larger accuracy value means less accurate)
//            if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
//                // clears out any previous error if there was one
//                lastLocationError = nil
//                location = newLocation
//
//                // if new location's accuracy is equal to or better than the desired accuracy, stop the location manager
//                if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
//                    stopLocationManager()
//
//                    if distance > 0 {
//                        performingReverseGeoCoding = false
//                    }
//                }
//
//                if !performingReverseGeoCoding{ // should only be performing one geocoding at a time
//                    performingReverseGeoCoding = true
//                    geocoder.reverseGeocodeLocation(newLocation) { (placemark, error) in
//                        if error == nil, let p = placemark, !p.isEmpty{
//                            self.placemark = p.last!
//                        }else{
//                            self.placemark = nil
//                        }
//
//                        self.performingReverseGeoCoding = false
//                    }
//                }
//            }
//            }
//        }
    
    func string(from placemark: CLPlacemark) ->String{
        let zipcodes = placemark.postalCode!
        return zipcodes
    }
    
       func updateLabels(){
         if location != nil{
             if let placemark = placemark{
                 let code = string(from: placemark)
                 zipcode.text = string(from: placemark)
                print ("djbsibdbciw")
                print(zipcode.text as Any)
                 print(code)
             }
         }
//         return zipcode.text!
     }
    //    MARK:- Get Weather
    func getWeather() {
        let session = URLSession.shared
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=10550,us&units=imperial&appid=18ad38c6774bd2096a9e97f4e0ff71aa")!
        let dataTask = session.dataTask(with: weatherURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the weather data:\n\(dataString!)")
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                            let cityName = jsonObj.value(forKey: "name")
                            if let temperature = mainDictionary.value(forKey: "temp") {
                                
                                DispatchQueue.main.async {
                                    self.weatherLabel.text = "\(cityName ?? "Brooklyn") Temperature: \(temperature)°F"
                                }
                            }
                        } else {
                            print("Error: unable to find temperature in dictionary")
                        }
                    } else {
                        print("Error: unable to convert json data")
                    }
                } else {
                    print("Error: did not receive data")
                }
            }
        }
        dataTask.resume()
    }
}
