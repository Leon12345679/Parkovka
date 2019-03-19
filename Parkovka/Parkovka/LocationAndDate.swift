//
//  Location and Date.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationAndDate: NSObject, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    func requestLocationUsage() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    // Used to set location based on virtual map pointer AKA the UBER feauture
    func GetLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        struct globals {
            static var address: String = ""
        }
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                if placemarks != nil {
                guard let placeMark = placemarks!.first else { return }
                
                globals.address = ""
                if let locality = placeMark.locality {
                    print(locality)
                   
                }
                if let thoroughfare = placeMark.thoroughfare {
                    print(thoroughfare)
                    globals.address += thoroughfare
                    globals.address += " "
                }
                if let subThoroughfare = placeMark.subThoroughfare {
                    print(subThoroughfare)
                    globals.address += subThoroughfare
                    globals.address += " "
                }
                if let administrativeArea = placeMark.administrativeArea {
                    print(administrativeArea)
                }
                } else {return}
                
        })
        
        if globals.address != "" {
        return globals.address
        } else {
            
            return ""
            
        }
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let thoroughfare = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            let subThoroughfare = (containsPlacemark.subThoroughfare != nil) ? containsPlacemark.subThoroughfare : ""
            // If containsPlacemark doesn't fail we can always get the coordinates
            let latitude = containsPlacemark.location?.coordinate.latitude
            let longitude = containsPlacemark.location?.coordinate.longitude
            UserDefaults.standard.set(latitude, forKey: "latitude")
            UserDefaults.standard.set(longitude, forKey: "longitude")
            UserDefaults.standard.set("область: Москва, ", forKey: "Region")
            UserDefaults.standard.set("город: Москва, ", forKey: "City")
            UserDefaults.standard.set("улица: \(thoroughfare!), дом: \(subThoroughfare!)", forKey: "Location")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
      
    }
    
    func getTime() -> String {
        
        let date = Date()
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        
        let minutes = calendar.component(.minute, from: date)
        
        var zeroBeforeMinutes = ""
        
        if minutes < 10 {
            zeroBeforeMinutes = "0"
        }
        return ("\(hour):\(zeroBeforeMinutes)\(minutes)")
    }





    func getSystemDate() -> String {
        
        let date = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: date)
        
    }

    func getTextDate() -> String {
        
        let date = Date()
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        
        let monthlist: Array = ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"]
        
        let month = monthlist[components.month! - 1]
        
        let day = components.day
        
        let DateString: String = "\(day!) \(month) \(year!)"
        
        return DateString
    }

}
