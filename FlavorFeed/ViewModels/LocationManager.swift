//
//  LocationManager.swift
//  FlavorFeed
//
//  Created by Michelle Lee on 11/10/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        //print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
       // print(#function, location)
    }
    
    func get_my_location() -> CLLocationCoordinate2D? {
        if let lat = self.lastLocation?.coordinate.latitude {
            if let long = self.lastLocation?.coordinate.longitude {
                let my_location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                return my_location
            }
        }
        return nil
    }
    
    func getPlaceFromLink(link: String) async -> Place? {
        let urlString = "https://api.foursquare.com\(link)"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        print(urlComponents.url?.absoluteString)
        var request = URLRequest(url: urlComponents.url!)
        
        // setting headers
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("fsq3WNw5aEH2EMpBBI2iRc4FU2sJHHQr/xJUhdvCYp/dHgI=", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        request.timeoutInterval = 5
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print("Data received (Size: \(data.count))")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            print("DATA: \(String(data: data, encoding: .utf8) ?? "Invalid JSON data")")
            
            let decodedResponse = try decoder.decode(Results.self, from: data)
            
            print("Places found: \(decodedResponse.results.count)")
            if decodedResponse.results.count == 1 {
                return decodedResponse.results[0]
            } else {
                return nil
            }
            
        } catch {
            print("Error: \(error)")
        }
        return nil
    }

}
