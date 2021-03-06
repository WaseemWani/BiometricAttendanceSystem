//
//  UIViewControllerExtension.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 26/04/21.
//

import Foundation
import UIKit

extension UINavigationController {
    func configureNavigationViewController() {
        self.navigationBar.barTintColor = AppConstants.theme
        self.navigationBar.tintColor = .white
        self.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, completionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandler))
        alert.view.tintColor = AppConstants.theme
        self.present(alert, animated: true)
    }
    
    func showToast(title: String?, message: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            alert.dismiss(animated: true, completion: completionHandler)
        }
    }
}
