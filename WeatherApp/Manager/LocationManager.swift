//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 26.08.2021.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    public var getCurrentLocation: ((WeatherModel.Coordinate?)->(Void))?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            getCurrentLocation?(WeatherModel.Coordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse:
                print("authorized")
                locationManager.requestLocation()
            case .denied:
                print("denied")
                getCurrentLocation?(nil)
            default:
                print("unknown")
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    getCurrentLocation?(nil)
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.requestLocation()
                @unknown default:
                    locationManager.requestWhenInUseAuthorization()
                  }
            } else {
                getCurrentLocation?(nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: cant find location")
    }
}
