//
//  StringExtension.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 26/04/21.
//

import Foundation

extension String {
    func validateMail() -> Bool {
        let emailRegx = "[A-z0-9]{1,}@[A-z]{1,}[\\.][A-z]{2,}$"
        let result = self ^=! emailRegx
        return result
    }
    
    func validateId() -> Bool {
        let IdRegx = "[0-9]"
        let result = self ^=! IdRegx
        return result
    }
    
    func validatePassword() -> Bool {
        let passwdRegx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&:;<>,.?/~_+-=]).{8,32}$"
        let result = self ^=! passwdRegx
        return result
    }

    fileprivate func matchRegex(pattern: String) -> Bool {
        let matchingRange = range(of: pattern, options: .regularExpression)
        return matchingRange == range(of: self)
    }
}

infix operator ^=!
func ^=! (input: String, pattern: String) -> Bool {
    return input.matchRegex(pattern: pattern)
}
