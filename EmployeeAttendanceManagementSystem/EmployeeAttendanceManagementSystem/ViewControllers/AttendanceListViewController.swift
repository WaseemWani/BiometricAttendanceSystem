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
            checkInDataSource = checkinData
            checkOutDataSource = checkOutData
        }
    }
    
    private func registerCell() {
        let nib = UINib.init(nibName: "AttendanceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AttendanceTableViewCell")
    }
}

extension AttendanceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SearchedAttendance.searchedAttendance.checkin.count == 0 {
            return checkInDataSource.count
        } else {
           return SearchedAttendance.searchedAttendance.checkin.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceTableViewCell") as? AttendanceTableViewCell else { return UITableViewCell() }
        
        if SearchedAttendance.searchedAttendance.checkin.count == 0 {
            guard checkInDataSource[indexPath.row].hasCheckedIn, let checkInTime = checkInDataSource[indexPath.row].time, let date = checkInDataSource[indexPath.row].date else { return UITableViewCell() }
            
            if checkOutDataSource.count < indexPath.row + 1 {
                cell.configureCell(with: checkInTime, checkOutTime: "Check out not done", date: date)
                return cell
            } else {
                cell.configureCell(with: checkInTime, checkOutTime: checkOutDataSource[indexPath.row].time ?? "", date: date)
                return cell
            }
        } else {
            let date = SearchedAttendance.searchedAttendance.checkin[indexPath.row].date ?? ""
            let checkInTime = SearchedAttendance.searchedAttendance.checkin[indexPath.row].time ?? ""
            let chekoutTime = SearchedAttendance.searchedAttendance.checkout[indexPath.row].time ?? ""
            cell.configureCell(with: checkInTime, checkOutTime: chekoutTime, date: date)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        searchController.searchBar.searchTextField.tintColor = UIColor(red: 0.76, green: 0.47, blue: 0.99, alpha: 1)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredData = SearchedAttendance(
            checkin: checkInDataSource.filter{($0.date?.localizedCaseInsensitiveContains(searchText))!},
            checkout: checkOutDataSource.filter { ($0.date?.localizedCaseInsensitiveContains(searchText))!})

        if !searchText.isEmpty && filteredData.checkin.isEmpty {
            showAlert(title: "Oops!", message: "No records found!") { [weak self] _ in
                searchBar.text = nil
                SearchedAttendance.searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
                self?.tableView.reloadData()
            }
        } else {
            SearchedAttendance.searchedAttendance = filteredData
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchedAttendance.searchedAttendance = SearchedAttendance(checkin: [], checkout: [])
        tableView.reloadData()
    }
}
