//
//  UserLocationManager.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 25.05.2023.
//

import Foundation
import Combine
import CoreLocation

protocol UserLocationService {
    var userAddressPublisher: AnyPublisher<String, Never> { get }
    func requestLocation()
}

final class UserLocationServiceImpl: NSObject {
    // MARK: - Private properties
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder
    
    // MARK: - Location publisher
    private let userAddressSubject = PassthroughSubject<String, Never>()
    lazy var userAddressPublisher = userAddressSubject.eraseToAnyPublisher()
    
    // MARK: - Init
    init(locationManager: CLLocationManager = CLLocationManager(), geocoder: CLGeocoder = CLGeocoder()) {
        self.locationManager = locationManager
        self.geocoder = geocoder
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - UserLocationService
extension UserLocationServiceImpl: UserLocationService {
    func requestLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension UserLocationServiceImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO: - Fix after demo
        switch status {
        case .notDetermined:          locationManager.requestWhenInUseAuthorization()
        case .restricted:             locationManager.requestWhenInUseAuthorization()
        case .denied:                 break
        case .authorizedAlways:       break
        case .authorizedWhenInUse:    break
        case .authorized:             break
        @unknown default:             break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        convertCoordinateToString(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Private extension
private extension UserLocationServiceImpl {
    func convertCoordinateToString(_ coordinate: CLLocation) {
        geocoder.reverseGeocodeLocation(coordinate) { [weak self] placemarks, _ in
            guard let self = self,
                  let placemarks = placemarks,
                  let placemark = placemarks.last,
                  let address = placemark.compactAddress else {
                return
            }
            self.userAddressSubject.send(address)
        }
    }
}

// TODO: - Delete when I switch to Google Maps
extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
//            if let street = thoroughfare {
//                result += ", \(street)"
//            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
