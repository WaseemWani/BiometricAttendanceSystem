//
//  ViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 17/04/21.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var errorLabelBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        self.title = "SIGN UP"
        signupButton.addShadow()
        nameTextField.delegate = self
        emailTextField.delegate = self
        idTextField.delegate = self
        signupButton.roundCorners()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if nameTextField.text!.isEmpty || emailTextField.text!.isEmpty || idTextField.text!.isEmpty {
            errorLabel.text = AppConstants.emptyTextFieldsErrorText
            errorLabel.textColor = .red
        } else if !emailTextField.text!.validateMail() {
            errorLabel.text = AppConstants.inValidEmailErrorText
            errorLabel.textColor = .red
        } else {
            errorLabel.text = nil
            if AppConstants.UserId.adminId.contains(idTextField.text!) || AppConstants.UserId.employeeId.contains(idTextField.text!) {
                if hasUserAlreadyRegistered(id: idTextField.text!) {
                    errorLabel.text = "User with id \(idTextField.text!) already exists."
                    errorLabel.textColor = .red
                } else {
                    errorLabel.text = nil
                    showSetUpPasswordViewController()
                }
            } else {
                showAlert(title: "Error", message: "Details not found!", completionHandler: nil)
            }
        }
    }
    
    private func hasUserAlreadyRegistered(id: String) -> Bool {
        var hasRegistered: Bool = false
        for user in RegisteredUsers.registeredUsers {
            if id == String(user.employeeId) {
                hasRegistered = true
                break
            } else {
                hasRegistered =  false
            }
        }
        return hasRegistered
    }
        
    private func showSetUpPasswordViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let setUpPasswordViewController = storyboard.instantiateViewController(withIdentifier: "SetupPasswordViewController") as? SetupPasswordViewController else { return }
        User.user = User(name: nameTextField.text!, email: emailTextField.text!, id: idTextField.text!, role: "", password: "")
        navigationController?.pushViewController(setUpPasswordViewController, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        errorLabelBottomConstraint.constant = 150
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            let email = textField.text!
            if !email.validateMail() {
                errorLabel.text = AppConstants.inValidEmailErrorText
                errorLabel.textColor = .red
            } else {
                errorLabel.text = nil
                textField.resignFirstResponder()
                idTextField.becomeFirstResponder()
            }
        } else if textField == idTextField {
            errorLabelBottomConstraint.constant = 15
            textField.resignFirstResponder()
        }
        if !nameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !idTextField.text!.isEmpty {
            errorLabel.text = nil
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == idTextField {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength && string.validateId()
        } else {
            return true
        }
    }
}
