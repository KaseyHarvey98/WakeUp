//
//  Morning.swift
//  WakeUP
//
//  Created by Kasey Harvey on 4/20/20..
//  Copyright © 2020 Kasey Harvey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVFoundation

class Morning : UIViewController, CLLocationManagerDelegate {
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
    
    var address = ""
    var saveZipcode = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let x = UserDefaults.standard.object(forKey: "name") as? String{
            name = x
        }
        if let x = UserDefaults.standard.object(forKey: "location") as? String{
            saveZipcode = x
            if x.isEmpty {
                saveZipcode = "postal_code=27601&country=US"
            }
        }
        greetingLabel.text = "Good Morning " + name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getWeather()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.getForecast()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getLocation()
    }
    // MARK:- Get Location
    func getLocation(){
        // Asking for Permission
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
    // If location permission denies
    func showLocationDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Start locating
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy =
            kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    // Stop locating
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    // Manages if no location was found
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
    // Manages if location was found
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        // Checks for accuracy from initial location
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
            stopLocationManager()
        }
        updateLabels()
        // Gets zipcode and country from user's device
        if !performingReverseGeocoding {
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
    // Returns zipcode and country from user's location
    func string(from placemark: CLPlacemark) -> String {
        var line = ""
        if let s = placemark.postalCode {
            line += "postal_code=" + s
        }
        if let s = placemark.isoCountryCode {
            line += "&country=" + s
        }
        if line.isEmpty {
            saveZipcode = "postal_code=27601&country=US"
        }
        UserDefaults.standard.set(line, forKey: "location")
        return line
        
    }
    
    func updateLabels(){
        // Saves updated location
        if location == location {
            if let placemark = placemark {
                address = string(from: placemark)
                saveZipcode = address
            }
        }else {
            address = ""
            // Error messages
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
    //    MARK:- Get Current Weather
    func getWeather() {
        let session = URLSession.shared
        // Api webite
        let weatherURL = URL(string:"https://api.weatherbit.io/v2.0/current?&\(self.saveZipcode)&units=I&key=92bc115e8b094ca6a3cb53fbcd569198")!
        
        // Start session
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
                        let weatherData = (jsonObj["data"]as! NSArray)
                        // Access "Weather's" data
                        if let aDictionary = weatherData[0] as? NSDictionary{
                            // access data for decription
                            if let dDictionary =  aDictionary.value(forKey: "weather")as? NSDictionary{
                                // Get value of temp
                                if  let temperature = aDictionary.value(forKey: "temp"),                                    //Get value of city
                                    let cityName = aDictionary.value(forKey: "city_name"),
                                    // Get decriptions for sky
                                    let description = dDictionary.value(forKey: "description"),
                                    // Get Real Feel temperature
                                    let realFeel = aDictionary.value(forKey: "app_temp")
                                {
                                    DispatchQueue.main.sync {
                                        //Displays Weather info
                                        let line1 = "Current Weather for \(cityName)"
                                        let line2 = "Current Temperatue : \(Int(temperature as! Double))°F"
                                        let line3 = "The sky shows \(description)."
                                        let line4 = "Feels Like : \(Int(realFeel as! Double))°F"
                                        self.weatherLabel.text = "\n" + line1 + "\n" + line2 + "\n" + line3 + "\n" + line4
                                        // Calls text to peech to say current weather
                                        self.textToSpeechC(name: "\(self.greetingLabel.text ?? "Kasey")", temp: "\(Int(temperature as! Double))",decription: "\(description)" ,realFeel: "\(Int(realFeel as! Double))" )
                                    }
                                }}
                        } else // list of error codes
                        {
                            print("Error: unable to find key in dictionary")
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
    //MARK:- Get Forecast
    func getForecast() {
        let session = URLSession.shared
        // Api webite
        let weatherURL = URL(string:"http://api.weatherbit.io/v2.0/forecast/daily?&\(self.saveZipcode)&units=I&key=92bc115e8b094ca6a3cb53fbcd569198")!
        // Start session
        let dataTask = session.dataTask(with: weatherURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    // All data from weather API
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the forecast data:\n\(dataString!)")
                    // Use JSON to navigate
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        // Weather is a struct in api data
                        let weatherData = (jsonObj["data"]as! NSArray)
                        // Access "Weather's" data
                        if let aDictionary = weatherData[0] as? NSDictionary{
                            // Get value of lowest temp
                            if let temperatureL = aDictionary.value(forKey: "min_temp"),
                                // Get value of max temp
                                let temperatureH = aDictionary.value(forKey: "max_temp"),
                                // Get decriptions for sky
                                let rain = aDictionary.value(forKey: "pop")
                                // Get Real Feel temperature
                            {
                                DispatchQueue.main.sync {
                                    //Displays Weather info
                                    let line0 = "Today's Forecast"
                                    let line1 = "High of : \(Int(temperatureH as! Double))°F"
                                    let line2 = "Low of : \(Int(temperatureL as! Double))°F"
                                    let line3 = "Precipitation : \(Int(rain as! Double))°F"
                                    self.weatherLabel.text! += "\n" + line0 + line1 + "\n" + line2 + "\n" + line3
                                    // Calls text to peech to say current weather
                                    self.textToSpeechF(tempH: "\(Int(temperatureH as! Double))",tempL: "\(Int(temperatureL as! Double))" ,rain: "\(Int(rain as! Double))" )
                                }
                            }
                        } else // list of error codes
                        {
                            print("Error: unable to find key in dictionary")
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
    func textToSpeechC(name: String, temp: String, decription: String, realFeel: String ){
        let utterance = AVSpeechUtterance(string: " \(name). The temperature is currently \(temp) degrees Fahrenheit, with \(decription). The real feel temperature is \(realFeel) degrees.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    func textToSpeechF(tempH: String, tempL: String, rain: String){
        let utterance = AVSpeechUtterance(string: " Today's forcast calls for a high of \(tempH) °, and a low of \(tempL) °. There is also a \(rain) chance of rain")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
