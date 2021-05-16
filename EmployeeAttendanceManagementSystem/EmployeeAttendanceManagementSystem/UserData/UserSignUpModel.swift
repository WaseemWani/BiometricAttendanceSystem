//
//  UserSignUpData.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 26/04/21.
//

import Foundation

struct User {
    var name: String
    var email: String
    var id: String
    var role: String
    var password: String
    
    static var user = User(name: "", email: "", id: "", role: "", password: "")
}
