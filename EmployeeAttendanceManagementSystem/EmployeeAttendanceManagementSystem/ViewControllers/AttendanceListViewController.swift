//
//  AttendanceListViewController.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 10/05/21.
//

import UIKit

private struct SearchedAttendance {
    var checkin: [Checkin]
    var checkout: [Checkout]
    
    static var searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
}

class AttendanceListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var checkInDataSource = [Checkin]()
    var checkOutDataSource = [Checkout]()
    var registeredEmployees = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ATTENDANCE"
        loadDataBase()
        registerCell()
        addSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SearchedAttendance.searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
    }
    
    private func loadDataBase() {
        guard let checkinData = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<Checkin>.checkIn),  let checkOutData = DatabaseManager.sharedInstance.retrieveData(modelType: CoreDataModelType<Checkout>.checkOut) else { return }
        if checkinData.isEmpty {
            showAlert(title: "Oops!", message: "No data found!") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            if User.user.role == AppConstants.adminRoleText {
                checkInDataSource = checkinData
                checkOutDataSource = checkOutData
                prepareDataSource(checkIndata: checkinData, checkOutData: checkOutData)
            } else {
                checkInDataSource = checkinData.filter({$0.employeeId == User.user.id})
                if checkInDataSource.isEmpty {
                    showAlert(title: "Oops!", message: "No data found!") { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    checkOutDataSource = checkOutData.filter({$0.employeeId == User.user.id})
                }
            }
        }
    }
    
    private func registerCell() {
        let nib = UINib.init(nibName: "AttendanceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AttendanceTableViewCell")
    }
    
    private func prepareDataSource(checkIndata: [Checkin], checkOutData: [Checkout]) {
        checkInDataSource = checkIndata.sorted { $0.employeeId! < $1.employeeId! }
        checkOutDataSource = checkOutData.sorted { $0.employeeId! < $1.employeeId! }
        let checkinEmps: Set<String> = Set(checkInDataSource.map({($0.employeeId ?? "")}))
        registeredEmployees = checkinEmps.sorted{$0 < $1}
    }
}

extension AttendanceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if User.user.role == AppConstants.adminRoleText {
            return registeredEmployees.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SearchedAttendance.searchedAttendance.checkin.count == 0 {
            if User.user.role == AppConstants.adminRoleText {
                return checkInDataSource.filter({$0.employeeId == String(registeredEmployees[section])}).count
            } else {
                return checkInDataSource.count
            }
        } else {
            if User.user.role == AppConstants.adminRoleText {
                return SearchedAttendance.searchedAttendance.checkin.filter({$0.employeeId == String(registeredEmployees[section])}).count
            } else {
                return SearchedAttendance.searchedAttendance.checkin.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceTableViewCell") as? AttendanceTableViewCell else { return UITableViewCell() }
        
        if SearchedAttendance.searchedAttendance.checkin.count == 0 {
            if User.user.role ==  AppConstants.adminRoleText {
                let filteredCheckins = self.checkInDataSource.filter({$0.employeeId == String(registeredEmployees[indexPath.section])})
                let filteredCheckouts = self.checkOutDataSource.filter({$0.employeeId == String(registeredEmployees[indexPath.section])})
                guard filteredCheckins[indexPath.row].hasCheckedIn,
                      let checkInTime = filteredCheckins[indexPath.row].time,
                      let date = filteredCheckins[indexPath.row].date else { return UITableViewCell() }
                let checkOutTime = getCheckOutTimeForCheckIn(checkin: filteredCheckins[indexPath.row], checkOuts: filteredCheckouts)
                print("checkout time is \(checkOutTime)")
                cell.configureCell(with: checkInTime, checkOutTime: checkOutTime, date: date)
                return cell
            } else {
                guard checkInDataSource[indexPath.row].hasCheckedIn,
                      let checkInTime = checkInDataSource[indexPath.row].time,
                      let date = checkInDataSource[indexPath.row].date else { return UITableViewCell() }
                let checkOutTime = getCheckOutTimeForCheckIn(checkin: checkInDataSource[indexPath.row], checkOuts: checkOutDataSource)
                print("checkout time is \(checkOutTime)")

                cell.configureCell(with: checkInTime, checkOutTime: checkOutTime, date: date)
                return cell
            }
        } else {
            if User.user.role ==  AppConstants.adminRoleText {
                let searchedFilteredCheckins = SearchedAttendance.searchedAttendance.checkin.filter({$0.employeeId == String(registeredEmployees[indexPath.section])})
                let searchedFilteredCheckouts = SearchedAttendance.searchedAttendance.checkout.filter({$0.employeeId == String(registeredEmployees[indexPath.section])})
                guard searchedFilteredCheckins[indexPath.row].hasCheckedIn,
                      let checkInTime = searchedFilteredCheckins[indexPath.row].time,
                      let date = searchedFilteredCheckins[indexPath.row].date else { return UITableViewCell() }
                if searchedFilteredCheckouts.count < indexPath.row + 1 {
                    cell.configureCell(with: checkInTime, checkOutTime: "Check out not done", date: date)
                    return cell
                } else {
                    let checkOutTime = getCheckOutTimeForCheckIn(checkin: searchedFilteredCheckins[indexPath.row], checkOuts: searchedFilteredCheckouts)
                    print("checkout time is \(checkOutTime)")

                    cell.configureCell(with: checkInTime, checkOutTime: checkOutTime, date: date)
                    return cell
                }
            } else {
                guard let checkInTime = SearchedAttendance.searchedAttendance.checkin[indexPath.row].time, let date = SearchedAttendance.searchedAttendance.checkin[indexPath.row].date else {
                    return UITableViewCell()
                }
                let checkOutTime = getCheckOutTimeForCheckIn(checkin: SearchedAttendance.searchedAttendance.checkin[indexPath.row], checkOuts: SearchedAttendance.searchedAttendance.checkout)
                print("checkout time is \(checkOutTime)")

                cell.configureCell(with: checkInTime, checkOutTime: checkOutTime, date: date)
                return cell
            }
        }
    }
    
    func getCheckOutTimeForCheckIn(checkin: Checkin, checkOuts: [Checkout]) -> String {
        var checkOutTime: String = "Check out not done"
        for checkout in checkOuts {
            if  checkin.date == checkout.date, let chkOutTime = checkout.time {
                checkOutTime = chkOutTime
                break
            } else {
                checkOutTime = "Check out not done"
            }
        }
        return checkOutTime
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if User.user.role == AppConstants.adminRoleText {
            return 20
        } else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if User.user.role == AppConstants.adminRoleText {
            let headerLabel = UILabel(frame: tableView.frame)
            headerLabel.text = "    Employee with id \(registeredEmployees[section])"
            headerLabel.font = UIFont(name: "System Font", size: 15)
            headerLabel.textColor = AppConstants.theme
            return headerLabel
        } else {
            return nil
        }
    }
}

extension AttendanceListViewController : UISearchBarDelegate {
    
    func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        searchController.searchBar.tintColor = .white
        searchController.searchBar.sizeToFit()
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.placeholder = "search attendance by date"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = AppConstants.theme
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredAttendance = SearchedAttendance(
            checkin: checkInDataSource.filter{($0.date?.localizedCaseInsensitiveContains(searchText))!},
            checkout: checkOutDataSource.filter {($0.date?.localizedCaseInsensitiveContains(searchText))!})

        if !searchText.isEmpty && filteredAttendance.checkin.isEmpty {
            showAlert(title: "Oops!", message: "No records found!") { [weak self] _ in
                searchBar.text = nil
                SearchedAttendance.searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
                self?.tableView.reloadData()
            }
        } else {
            SearchedAttendance.searchedAttendance = filteredAttendance
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchedAttendance.searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
        tableView.reloadData()
    }
}
