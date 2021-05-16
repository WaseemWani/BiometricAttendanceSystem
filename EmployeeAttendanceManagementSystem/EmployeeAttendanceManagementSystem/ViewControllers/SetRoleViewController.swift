//
//  SetRoleViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 18/04/21.
//

import UIKit

private enum Segements: Int {
  case admin
  case employee
}

class SetRoleViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var roleSegmentControl: UISegmentedControl!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SET YOUR ROLE"
        self.navigationItem.backButtonTitle = " "
        signUpButton.addShadow()
        signUpButton.roundCorners()
        shouldEnableButton(shouldEnable: false)
        configureSegmentControl()
    }
    
    private func configureSegmentControl() {
        roleSegmentControl.selectedSegmentIndex = Segements.employee.rawValue
        if AppConstants.UserId.employeeId.contains(User.user.id) {
            errorLabel.text = AppConstants.eligibleToSignUpText
            errorLabel.textColor = #colorLiteral(red: 0.7573277354, green: 0.4704928994, blue: 0.9946855903, alpha: 1)
            shouldEnableButton(shouldEnable: true)
        } else {
            errorLabel.text = AppConstants.signUpAsAdminErrorText
            errorLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            shouldEnableButton(shouldEnable: false)
        }
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        if roleSegmentControl.selectedSegmentIndex == Segements.admin.rawValue {
            if AppConstants.UserId.adminId.contains(User.user.id) {
                errorLabel.text = AppConstants.eligibleToSignUpText
                errorLabel.textColor = #colorLiteral(red: 0.7573277354, green: 0.4704928994, blue: 0.9946855903, alpha: 1)
                shouldEnableButton(shouldEnable: true)
            } else {
                errorLabel.text = AppConstants.notEligibleToSignUpText
                errorLabel.textColor = .red
                shouldEnableButton(shouldEnable: false)
            }
        } else {
            if AppConstants.UserId.adminId.contains(User.user.id) {
                errorLabel.text = AppConstants.signUpAsAdminErrorText
                errorLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                shouldEnableButton(shouldEnable: false)
            } else {
                errorLabel.text = AppConstants.eligibleToSignUpText
                errorLabel.textColor = #colorLiteral(red: 0.7573277354, green: 0.4704928994, blue: 0.9946855903, alpha: 1)
                shouldEnableButton(shouldEnable: true)
            }
        }
    }
    
    private func shouldEnableButton(shouldEnable: Bool) {
        signUpButton.isEnabled = shouldEnable
        if shouldEnable {
            signUpButton.backgroundColor = #colorLiteral(red: 0.7573277354, green: 0.4704928994, blue: 0.9946855903, alpha: 1)
        } else {
            signUpButton.backgroundColor = .lightGray
        }
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
//        let defaults = UserDefaults.standard
        UserDefaults.standard.set(true, forKey: AppConstants.signUpCompletedKey)
        saveRole()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        showToast(title: nil, message: "Signed up successfully") { [weak self]  in
            self?.navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
    
    func saveRole() {
//        let defaults = UserDefaults.standard
        var role = ""
        if roleSegmentControl.selectedSegmentIndex == Segements.admin.rawValue {
            role = AppConstants.adminRoleText
        } else {
            role = AppConstants.employeeRoleText
        }
        User.user.role = role
        saveUserData()
//        defaults.set(role, forKey: AppConstants.roleKey)
    }
    
    private func saveUserData() {
        DatabaseManager.sharedInstance.saveData(modelType: CoreDataModelType<UserEntity>.user) { userEntity in
            userEntity.name = User.user.name
            userEntity.email = User.user.email
            if let id = Int16(User.user.id) {
                userEntity.employeeId = id
            } else {
                userEntity.employeeId = 0
            }
            userEntity.role = User.user.role
            userEntity.password = User.user.password
        }
    }
}
