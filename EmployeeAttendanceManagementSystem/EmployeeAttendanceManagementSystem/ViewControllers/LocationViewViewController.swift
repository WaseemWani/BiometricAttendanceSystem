//
//  LocationViewViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 24/04/21.
//

import UIKit
import MapKit
import CoreData

class LocationViewViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var saveLocationButton: UIButton!
    
    var annotation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "SET LOCATION"
        saveLocationButton.roundCorners(cornerRadius: 6)
        saveLocationButton.addShadow()
        saveLocationButton.alpha = 0.8
        mapView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressMapview(recognizer:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let result = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<OfficeLocation>.officeLocation) else { return }
        if !result.isEmpty {
            if let latitude = result.first?.latitude, let longitude = result.first?.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.addAnnotation(annotation)
            }
            showAlert(title: "Oops!", message: "You have already saved the location", completionHandler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        } else {
            mapView.setRegion(AppConstants.region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = AppConstants.currentLocation
            mapView.showsUserLocation = true
            mapView.addAnnotation(annotation)
            self.annotation = annotation
        }
    }
    
    @objc func didLongPressMapview(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: mapView)
        let touchPointCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchPointCoordinates
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotation(annotation)
        self.annotation = annotation
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if annotation != nil {
            DatabaseManager.sharedInstance.saveData(modelType: CoreDataModelType<OfficeLocation>.officeLocation) { result in
                result.latitude = self.annotation.coordinate.latitude
                result.longitude = self.annotation.coordinate.longitude
                self.showToast(title: "Done", message: "Location saved successfully", completionHandler: { self.navigationController?.popViewController(animated: true)
                })
            }
        } else {
            self.showAlert(title: "Oops!", message: "Please mark a location on the map first", completionHandler: nil)
        }
    }
}

extension LocationViewViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Office Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}
