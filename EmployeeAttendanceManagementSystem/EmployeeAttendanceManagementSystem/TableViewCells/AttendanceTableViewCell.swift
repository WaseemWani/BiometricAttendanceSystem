//
//  AttendanceTableViewCell.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 10/05/21.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var checkinLabel: UILabel!
    @IBOutlet var checkInTimeLabel: UILabel!
    @IBOutlet var checkoutLabel: UILabel!
    @IBOutlet var checkOutTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.checkinLabel.text = "Check in"
        self.checkoutLabel.text = "Check out"
        self.backgroundColor = .clear
        contentView.roundCorners(cornerRadius: 10)
        self.addShadow(shadowOpacity: 0.3, shadowRadius: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func configureCell(with checkinTime: String, checkOutTime: String, date: String) {
        self.dateLabel.text = date
        self.checkInTimeLabel.text = checkinTime
        self.checkOutTimeLabel.text = checkOutTime
    }
}
