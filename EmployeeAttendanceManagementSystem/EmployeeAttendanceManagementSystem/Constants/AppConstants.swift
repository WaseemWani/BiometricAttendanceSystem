//
//  AppConstants.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 26/04/21.
//

import Foundation
import CoreLocation
import MapKit

struct AppConstants {
    static let nameKey = "nameKey"
    static let emailKey = "emailKey"
    static let idKey = "idKey"
    static let passwordKey = "passwordKey"
    static let signUpCompletedKey = "signUpCompletedKey"
    static let roleKey = "roleKey"
    static let loggedInKey = "LoggedInKey"
    
    static let inValidEmailErrorText = "Please enter a valid email Id."
    static let emptyTextFieldsErrorText = "Please fill all the fields."
    static let strongPasswordErrorText = "Please enter a strong password of atleast 8 characters including uppercase, lower case letters, numbers and special symbols."
    static let passwordMismatchErrorText = "Password mismatch."
    static let eligibleToSignUpText = "You are eligible to sign up."
    static let notEligibleToSignUpText = "You are not eligible to sign up as Admin. You can sign up as an employee."
    static let signUpAsAdminErrorText = "You can sign up as Admin."
    
    static let adminRoleText = "Admin"
    static let employeeRoleText = "Employee"
    
    struct UserId {
        static let employeeId = ["1234", "2023","1101","1102","1103","1104","1105"]
        static let adminId = ["1800", "6610"]
    }
    
    static var currentLocation =  CLLocationCoordinate2D()
    static var region = MKCoordinateRegion()
    
    static let theme = UIColor(red: 0.76, green: 0.47, blue: 0.99, alpha: 1)
}
