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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        locationSetUp()
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if UserDefaults.standard.bool(forKey: AppConstants.loggedInKey) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            let navVC = UINavigationController(rootViewController: homeViewController)
            navVC.configureNavigationViewController()
            homeViewController.navigationItem.backButtonTitle = " "
            window?.rootViewController = navVC
        } else if UserDefaults.standard.bool(forKey: AppConstants.signUpCompletedKey) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            let navVC = UINavigationController(rootViewController: loginViewController)
            navVC.configureNavigationViewController()
            loginViewController.navigationItem.backButtonTitle = " "
            window?.rootViewController = navVC
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            AppConstants.region = region
        }
        guard let location = manager.location?.coordinate else { return }
        AppConstants.currentLocation = location
    }
}
