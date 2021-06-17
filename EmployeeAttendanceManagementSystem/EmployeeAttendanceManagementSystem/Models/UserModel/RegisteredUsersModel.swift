//
//  RegisteredUsersModel.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 21/05/21.
//

import Foundation

struct RegisteredUsers {
   static var registeredUsers: [UserEntity] {
        if let unwrappedUsers = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<UserEntity>.user) {
            return unwrappedUsers
        } else {
            return []
        }
    }
}
