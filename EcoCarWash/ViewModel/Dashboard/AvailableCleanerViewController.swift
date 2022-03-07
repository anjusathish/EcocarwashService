//
//  AvailableCleanerViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 13/01/22.
//

import UIKit

protocol AssignCleanerDelegate {
    func assignCleaner(userId: String)
    func cancelAppointment(isCancelled: Bool)
}

class AvailableCleanerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: Constants.TableViewCellID.CleanerCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.CleanerCell)
        }
    }
    
    lazy var viewModel: CleanerViewModel = {
        return CleanerViewModel()
    }()

    var cleanerData: [Cleaner] = []
    var selectedDate: String = ""
    var delegate: AssignCleanerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.availableCleanersOn(date: selectedDate)
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// #MARK: - Tableview Methods
extension AvailableCleanerViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleanerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.CleanerCell, for: indexPath) as! CleanerCell
        
        cell.configureCell(data: cleanerData[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let assignedCleanerUserId = cleanerData[indexPath.row].uuid {
            delegate.assignCleaner(userId: assignedCleanerUserId)
        }
    }

}

// #MARK: - CleanerDelegate Methods
extension AvailableCleanerViewController: CleanerDelegate {
   
    func getCleanerList(_cleanerListInfo: [Cleaner]) {
        cleanerData = _cleanerListInfo
        tableView.reloadData()
    }
    
    func successful(message: String) {
        
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}
