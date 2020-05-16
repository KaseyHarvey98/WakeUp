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
import AVFoundation

class Morning : UIViewController, CLLocationManagerDelegate {
      var address = ""
      var saveZipcode = ""
      var name = ""
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    @IBAction func End(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
     }
    
    
    
    //GeoCoding
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    
    let locationManager = CLLocationManager() // this object will give us the GPS Coordinates
    var location: CLLocation? // this stores the user's current location and changes as new GPS coordinates come in
    var updatingLocation = false // Checking if the app is trying to get GPS coordinates
    var lastLocationError: Error?
    
    override func viewDidLoad() {
        if let x = UserDefaults.standard.object(forKey: "name") as? String{
            name = x
        }
        super.viewDidLoad()
        greetingLabel.text = "Good Morning " + name
        print("name 38")
        print(greetingLabel.text!)
        getLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getWeather()
        }
        
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
        placemark = nil
        lastGeocodingError = nil
        startLocationManager()
        updateLabels()
    }
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy =
            kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        } }
    func showLocationDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        if (error as NSError).code ==
            CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
//        print("didUpdateLocations \(newLocation)")
        if newLocation.timestamp.timeIntervalSinceNow < -2 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        if location == nil || location!.horizontalAccuracy >
            newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
        }
        if newLocation.horizontalAccuracy <=
            locationManager.desiredAccuracy {
            print("*** We’re done!")
            stopLocationManager()
        }
        updateLabels()
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true
            geocoder.reverseGeocodeLocation(newLocation, completionHandler:
                { placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
            }
            )}
    }
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let s = placemark.postalCode {
            line1 += s + ","
        }
        if let s = placemark.isoCountryCode {
            line1 += s
        }
        return line1
        
    }
    func updateLabels(){
        if location == location {
            address = ""
            if let placemark = placemark {
                address = string(from: placemark)
                saveZipcode = address
            } else if performingReverseGeocoding {
                address = ""
            } else if lastGeocodingError != nil {
                address = "Error Finding Address"
            } else {
                address = "No Address Found"
            }
        } else {
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain &&
                    error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                    print(statusMessage)
                    
                } else {
                    statusMessage = "Error Getting Location"
                    print(statusMessage)
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
                print(statusMessage)
                
            } else if updatingLocation {
                statusMessage = "Searching..."
                print(statusMessage)
            }}}
    //    MARK:- Get Weather
    func getWeather() {
        print("zip \(saveZipcode)")
        let session = URLSession.shared
        let weatherURL = URL(string:"http://api.openweathermap.org/data/2.5/weather?zip=\(self.saveZipcode)&units=imperial&APPID=18ad38c6774bd2096a9e97f4e0ff71aa")!
        
        let dataTask = session.dataTask(with: weatherURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    // All data from weather API
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the weather data:\n\(dataString!)")
                    // Use JSON to navigate
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                       // Weather is a struct in api data
                        let weatherData = (jsonObj["weather"]as! NSArray)
                        // Access "Weather's" data
                        if let aDictionary = weatherData[0] as? NSDictionary{
                            // Access data in other part of API Response
                            if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                                // Get value of temp
                                if let temperature = mainDictionary.value(forKey: "temp"),
                                    //Get value of city
                                    let cityName = jsonObj.value(forKey: "name"),
                                    // Get decriptions for sky
                                    let description = aDictionary.value(forKey: "description"),
                                    // Get Real Feel temperature
                                    let realFeel = mainDictionary.value(forKey: "feels_like")
                                {
                                    DispatchQueue.main.sync {
                                        //Displays Weather info
                                        self.weatherLabel.text = "\(cityName ) Temperature: \(Int(temperature as! Double))°F"
                                        // Calls text to peech to say current weather
                                        self.textToSpeech(name: "\(self.greetingLabel.text ?? "Kasey")", temp: "\(Int(temperature as! Double))",decription: "\(description)" ,realFeel: "\(realFeel)" )
                                    }
                                }}
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
    // MARK:- Good Morning Speech
    func textToSpeech(name: String, temp: String, decription: String, realFeel: String  ){
        let utterance = AVSpeechUtterance(string: " \(name). The temperature is currently \(temp) degrees with \(decription). The real feel temperature is \(realFeel) degrees.")
        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
