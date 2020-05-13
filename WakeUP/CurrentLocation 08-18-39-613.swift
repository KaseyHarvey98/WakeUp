//
//import UIKit
//import CoreLocation
//
//class CurrentLocation: UIViewController, CLLocationManagerDelegate {
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var latitudeLabel: UILabel!
//    @IBOutlet weak var longitudeLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var getButton: UIButton!
//    let locationManager = CLLocationManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        updateLabels()
//        getLocation()
//
//        // Do any additional setup after loading the view.
//    }
//        
//    @IBAction func getLocation() {
//        locationManager.delegate = self
//         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//         locationManager.startUpdatingLocation()
//    }
//    
//    // MARK: - CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager,
//            didFailWithError error: Error) {
//      print("didFailWithError \(error.localizedDescription)")
//    }
//    func locationManager(_ manager: CLLocationManager,
//      didUpdateLocations locations: [CLLocation]) {
//      let newLocation = locations.last!
//      print("didUpdateLocations \(newLocation)")
//    }
//   
//}
