//
//  SetupPasswordViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 17/04/21.
//

import UIKit

class SetupPasswordViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var checkBoxImageView: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var showPasswordBottomConstraint: NSLayoutConstraint!
    
    var isPassWordShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SET YOUR PASSWORD"
        setupNextButton()
        addTapGesture()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapImageView(_: Any) {
        if isPassWordShown {
            checkBoxImageView.image = UIImage(systemName: "square")
            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = true
            isPassWordShown = false
        } else {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square")
            passwordTextField.isSecureTextEntry = false
            confirmPasswordTextField.isSecureTextEntry = false
            isPassWordShown = true
        }
    }
    
    private func setupNextButton() {
        nextButton.roundCorners()
        nextButton.addShadow()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty {
            errorLabel.text = AppConstants.emptyTextFieldsErrorText
            errorLabel.textColor = .red
        } else {
            errorLabel.text = nil
            savePassword()
            showSetRoleViewController()
        }
    }
    
    private func showSetRoleViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let setRoleViewController = storyboard.instantiateViewController(withIdentifier: "SetRoleViewController") as? SetRoleViewController else { return }
        User.user.password = confirmPasswordTextField.text!
        navigationController?.pushViewController(setRoleViewController, animated: true)
    }
    
    private func savePassword() {
        User.user.password = confirmPasswordTextField.text!
    }
    
    private func shouldEnableButton(shouldEnable: Bool) {
        nextButton.isEnabled = shouldEnable
        if shouldEnable {
            nextButton.backgroundColor = #colorLiteral(red: 0.7573277354, green: 0.4704928994, blue: 0.9946855903, alpha: 1)
        } else {
            nextButton.backgroundColor = .lightGray
        }
    }
}

extension SetupPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            let currentString = textField.text! as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            if !newString.validatePassword() {
                errorLabel.text = AppConstants.strongPasswordErrorText
                errorLabel.textColor = .red
                shouldEnableButton(shouldEnable: false)
            } else {
                errorLabel.text = nil
                shouldEnableButton(shouldEnable: true)
            }
        }
        if textField == confirmPasswordTextField {
            errorLabel.text = nil
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showPasswordBottomConstraint.constant = 150
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        }
        
        if textField == confirmPasswordTextField {
            if textField.text != passwordTextField.text {
                errorLabel.text = AppConstants.passwordMismatchErrorText
                errorLabel.textColor = .red
                shouldEnableButton(shouldEnable: false)
            } else {
                errorLabel.text = nil
                shouldEnableButton(shouldEnable: true)
                showPasswordBottomConstraint.constant = 50
                confirmPasswordTextField.resignFirstResponder()
                if !confirmPasswordTextField.text!.validatePassword() {
                    errorLabel.text = AppConstants.strongPasswordErrorText
                    errorLabel.textColor = .red
                    shouldEnableButton(shouldEnable: false)
                } else {
                    errorLabel.text = nil
                    shouldEnableButton(shouldEnable: true)
                }
            }
        }
        return true
    }
}
