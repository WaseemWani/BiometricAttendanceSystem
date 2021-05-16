//
//  DateExtension.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 09/05/21.
//

import Foundation

extension Date {
    func getLocalizedDate() -> String {
        let locaDateFormatter = DateFormatter()
        locaDateFormatter.dateStyle = .long
        return locaDateFormatter.string(from: self)
    }
    
    func getLocalizedTime() -> String {
        let localTimeFormatter = DateFormatter()
        localTimeFormatter.timeStyle = .long
        var time = localTimeFormatter.string(from: self)
        time = time.replacingOccurrences(of: "IST", with: "")
        return time
    }
}
