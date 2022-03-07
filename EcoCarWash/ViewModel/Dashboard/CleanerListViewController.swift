//
//  CleanerListViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 29/12/21.
//

import UIKit

class CleanerListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: Constants.TableViewCellID.CleanerCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.CleanerCell)
        }
    }
    
    lazy var viewModel: CleanerViewModel = {
        return CleanerViewModel()
    }()
    
    lazy var leaveViewModel: LeaveViewModel = {
        return LeaveViewModel()
    }()

    var selectedIndexPath: IndexPath?
    var cleanerData: [Cleaner] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCleanerList()
    }
    
    @IBAction func addCleanerBtn(_ sener: UIButton) {
        let vc = Utilities.sharedInstance.cleanerController(identifier: Constants.StoryboardIdentifier.createCleanerVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sener: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// #MARK: - Tableview Methods
extension CleanerListViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleanerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.CleanerCell, for: indexPath) as! CleanerCell
        
        if indexPath == selectedIndexPath {
            cell.expand()
        } else {
            cell.collapse()
        }

        cell.actionBtn.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
        cell.actionBtn.tag = indexPath.row
        
        cell.configureCell(data: cleanerData[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    @objc func performAction(_ sender: UIButton) {
        
        let cleanerData = cleanerData[sender.tag]
        
        if let leave = cleanerData.userLeave, let status = leave.status {
            if let cleanerStatus = CleanerStatus(rawValue: status) {
                switch cleanerStatus {
                case .Available:
                    break
                case .Offline:
                    break
                case .Approved:
                    break
                case .Applied:
                    
                    if let userType = UserManager.shared.currentUser?.userType {
                        if let type = UserType(rawValue: userType) {
                            if type == .manager {
                                if let id = leave.id {
                                    let request = UpdateLeaveRequest(is_approved: true)
                                    leaveViewModel.updateLeave(id: "\(id)", request: request)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _indexPath = selectedIndexPath {

            makeCellUnSelected(in: tableView, on: _indexPath)
            
            guard _indexPath != indexPath  else {
                tableView.deselectRow(at: _indexPath , animated: true)
                self.selectedIndexPath = nil
                tableView.beginUpdates()
                tableView.endUpdates()
                return
            }
        }

        makeCellSelected(in: tableView, on: indexPath)
        selectedIndexPath = indexPath
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func makeCellSelected(in tableView: UITableView, on indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CleanerCell {
            cell.expand()
        }
    }

    func makeCellUnSelected(in tableView: UITableView, on indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CleanerCell {
            cell.collapse()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let cleanerLeaveStatus = cleanerData[indexPath.row].userLeave?.status {
            if CleanerStatus(rawValue: cleanerLeaveStatus) == .Available {
                return indexPath == selectedIndexPath ? 220 : 120
            }
            return indexPath == selectedIndexPath ? 310 : 120
        }
        return 1
    }
}

// #MARK: - CleanerDelegate Methods
extension CleanerListViewController: CleanerDelegate {
   
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
