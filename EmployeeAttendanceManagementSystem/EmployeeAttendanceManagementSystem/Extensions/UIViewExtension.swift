//
//  UIViewExtension.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 26/04/21.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), shadowOpacity: Float = 1, shadowOffset: CGSize = .zero, shadowRadius: CGFloat = 10) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
    
    func roundCorners(cornerRadius: CGFloat = 23) {
        self.layer.cornerRadius = cornerRadius
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
