//
//  ProfileViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 09/05/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profileContainerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var nameContainerView: UIView!
    @IBOutlet var emailContainerView: UIView!
    @IBOutlet var idLabelContainerView: UIView!
    @IBOutlet var roleContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        profileContainerView.layer.cornerRadius = 100
        profileContainerView.layer.maskedCorners = [.layerMinXMinYCorner]
        profileContainerView.addShadow(shadowOpacity: 0.5)
        nameContainerView.addShadow(shadowOpacity: 0.3, shadowRadius: 5)
        nameContainerView.roundCorners(cornerRadius: 10)
        emailContainerView.addShadow(shadowOpacity: 0.3, shadowRadius: 5)
        emailContainerView.roundCorners(cornerRadius: 10)
        idLabelContainerView.addShadow(shadowOpacity: 0.3, shadowRadius: 5)
        idLabelContainerView.roundCorners(cornerRadius: 10)
        roleContainerView.addShadow(shadowOpacity: 0.3, shadowRadius: 5)
        roleContainerView.roundCorners(cornerRadius: 10)
    }
    
    private func setupUI() {
        navigationItem.title = "PROFILE"
        nameLabel.text = User.user.name //UserDefaults.standard.string(forKey: AppConstants.nameKey)
        emailLabel.text = User.user.email //UserDefaults.standard.string(forKey: AppConstants.emailKey)
        idLabel.text = User.user.id //UserDefaults.standard.string(forKey: AppConstants.idKey)
        roleLabel.text = User.user.role //UserDefaults.standard.string(forKey: AppConstants.roleKey)
    }
}
