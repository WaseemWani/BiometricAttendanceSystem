//
//  HomeViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 24/04/21.
//

import UIKit
import LocalAuthentication
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet var greetingsLabel: UILabel!
    
    @IBOutlet var checkInView: UIView!
    @IBOutlet var checkInLabel: UILabel!
    @IBOutlet var checkinImageView: UIImageView!
    @IBOutlet var checkInButton: UIButton!
    
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var setLocationLabel: UILabel!
    
    @IBOutlet var attendanceView: UIView!
    @IBOutlet var listImageView: UIImageView!
    @IBOutlet var viewAttendanceLabel: UILabel!
    
    @IBOutlet var viewProfileView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var viewProfileLabel: UILabel!
    
    var id = UserDefaults.standard.string(forKey: AppConstants.idKey) ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser(for: id)
        setupUI()
    }
        
    private func getUser(for id: String) {
        let id = Int16(id) ?? 0
        let user = RegisteredUsers.registeredUsers.filter({$0.employeeId == id})
              let empId = user.first?.employeeId ?? 0
              let name = user.first?.name ?? ""
              let email = user.first?.email ?? ""
              let role = user.first?.role ?? ""
        User.user = User(name: name, email: email, id: String(empId), role: role, password: "")
    }

    private func setupUI() {
        addShadowAndRoundCorners()
        setNavigationBar()
        
        greetingsLabel.text = "Welcome  \(User.user.name.capitalized)!"
        profileImageView.image = UIImage(systemName: "person.circle")
        viewProfileLabel.text = "View profile"
        listImageView.image = UIImage(systemName: "list.bullet.rectangle")
        viewAttendanceLabel.text = "View attendance"
        
        if User.user.role == AppConstants.adminRoleText {
            checkinImageView.image = nil
            checkInLabel.text = nil
            checkInButton.isEnabled = false
            locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
            setLocationLabel.text = "Set office location"
        } else {
            checkinImageView.image = UIImage(systemName: "arrow.right.square")
            checkInLabel.text = "Check in       "
            checkInButton.isEnabled = true
            locationImageView.image = UIImage(systemName: "arrow.left.square")
            setLocationLabel.text = "Check out"
        }
    }
    
    private func addShadowAndRoundCorners() {
        locationView.roundCorners(cornerRadius: 10)
        locationView.addShadow(shadowOpacity: 0.5)
        attendanceView.roundCorners(cornerRadius: 10)
        attendanceView.addShadow(shadowOpacity: 0.5)
        viewProfileView.roundCorners(cornerRadius: 10)
        viewProfileView.addShadow(shadowOpacity: 0.5)
        if User.user.role == AppConstants.employeeRoleText {
            checkInView.roundCorners(cornerRadius: 10)
            checkInView.addShadow(shadowOpacity: 0.5)
        }
    }
    
    private func setNavigationBar() {
        self.title = "HOME"
        self.navigationItem.backButtonTitle = " "
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutTapped))
    }
    
    @objc func logOutTapped() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        UserDefaults.standard.set(false, forKey: AppConstants.loggedInKey)
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    @IBAction func checkInButtonAction(_ sender: Any) {
        if hasAlreadyCheckedIn {
            showAlert(title: "Oops!", message: "You have already checked in for today.", completionHandler: nil)
        } else {
            if isUserInOfficePremises {
                authenticateWithBiometrics() { [weak self] authenticated  in
                    if authenticated {
                        self?.checkin() {
                            self?.showAlert(title: "Success", message: "Checked in successfully!", completionHandler: nil)
                        }
                    } else {
                        self?.showAlert(title: "Authentication failed", message: "You could not be verified; please try again.", completionHandler: nil)
                    }
                }
            } else {
                showAlert(title: "Oops!", message: "Seems you are not in the office premises!", completionHandler: nil)
            }
        }
    }
    
    @IBAction func addLocationOrCheckOutButtionAction(_ sender: Any) {
        if User.user.role == AppConstants.adminRoleText {
            showLocationViewController()
        } else {
            performCheckout()
        }
    }
    
    private func showLocationViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewViewController") as? LocationViewViewController else { return }
        navigationController?.pushViewController(locationViewController, animated: true)
    }
    
    private func performCheckout() {
        if hasAlreadyCheckedOut {
            showAlert(title: "Oops!", message: "You have already checked out for today.", completionHandler: nil)
        } else {
            if hasAlreadyCheckedIn {
                if isUserInOfficePremises {
                    authenticateWithBiometrics() { [weak self] authenticated  in
                        if authenticated {
                            self?.checkout() {
                                self?.showAlert(title: "Success", message: "Checked out successfully!", completionHandler: nil)
                            }
                        } else {
                            self?.showAlert(title: "Authentication failed", message: "You could not be verified; please try again.", completionHandler: nil)
                        }
                    }
                } else {
                    showAlert(title: "Oops!", message: "Seems you are not in the office premises!", completionHandler: nil)
                }
            } else {
                showAlert(title: "Oops!", message: "You can not check out without checking in!", completionHandler: nil)
            }
        }
    }
    
    @IBAction func viewAttendanceButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let attendanceListViewController = storyBoard.instantiateViewController(withIdentifier: "AttendanceListViewController") as? AttendanceListViewController else { return }
        navigationController?.pushViewController(attendanceListViewController, animated: true)
    }
    
    @IBAction func viewProfileButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else  { return }
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension HomeViewController {
    func authenticateWithBiometrics(completion: @escaping (_ authenticated: Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            showAlert(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", completionHandler: nil)
        }
    }
}

extension HomeViewController {
    var isUserInOfficePremises: Bool {
        guard let officeLocation = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<OfficeLocation>.officeLocation) else { return false }
        var location = CLLocationCoordinate2D()
        location.latitude = officeLocation.first?.latitude ?? 0
        location.longitude = officeLocation.first?.longitude ?? 0
        if AppConstants.currentLocation.distance(from: location) <= 100 {
            return true
        } else {
            return false
        }
    }
    
    var hasAlreadyCheckedIn: Bool {
        if let checkinEntity = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<Checkin>.checkInByDate(Date().getLocalizedDate())), checkinEntity.first?.hasCheckedIn != nil {
            let filteredCheckIns = checkinEntity.filter({ $0.employeeId == User.user.id})
            return (!filteredCheckIns.isEmpty && filteredCheckIns.first?.hasCheckedIn != nil)
        } else {
            return false
        }
    }

    var hasAlreadyCheckedOut: Bool {
        if let checkOutEntity = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<Checkout>.checkOutByDate(Date().getLocalizedDate())) {
            let filteredCheckOuts = checkOutEntity.filter({$0.employeeId == User.user.id})
            return (!filteredCheckOuts.isEmpty && filteredCheckOuts.first?.hasCheckedOut != nil)
        } else {
            return false
        }
    }
    
    private func checkin(completion: @escaping () -> Void) {
        DatabaseManager.sharedInstance.saveData(modelType: CoreDataModelType<Checkin>.checkIn) { entity in
            entity.hasCheckedIn = true
            entity.employeeId = User.user.id
            entity.date = Date().getLocalizedDate()
            entity.time = Date().getLocalizedTime()
            completion()
        }
    }
    
    private func checkout(completion: @escaping () -> Void) {
        DatabaseManager.sharedInstance.saveData(modelType: CoreDataModelType<Checkout>.checkOut) { entity in
            entity.hasCheckedOut = true
            entity.employeeId = User.user.id
            entity.date = Date().getLocalizedDate()
            entity.time = Date().getLocalizedTime()
            completion()
        }
    }
}
