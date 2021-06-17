//
//  SceneDelegate.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 17/04/21.
//

import UIKit
import CoreLocation
import MapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        locationSetUp()
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if UserDefaults.standard.bool(forKey: AppConstants.loggedInKey) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            setRootViewController(in: homeViewController)
        } else if UserDefaults.standard.bool(forKey: AppConstants.signUpCompletedKey) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            setRootViewController(in: loginViewController)
        }
    }
}

extension SceneDelegate {
    private func setRootViewController(in viewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.configureNavigationViewController()
        viewController.navigationItem.backButtonTitle = " "
        window?.rootViewController = navVC
    }
}

extension SceneDelegate {
    func locationSetUp() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension SceneDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            AppConstants.region = region
        }
        guard let location = manager.location?.coordinate else { return }
        AppConstants.currentLocation = location
    }
}
