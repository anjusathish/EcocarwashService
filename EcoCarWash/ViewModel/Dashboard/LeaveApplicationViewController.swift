//
//  LeaveApplicationViewController.swift
//  Eco Car Wash Drive
//
//  Created by Indium Software on 06/10/21.
//

import UIKit

class LeaveApplicationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib.init(nibName: Constants.TableViewCellID.LeaveHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableViewCellID.LeaveHeaderView)
            tableView.register(UINib.init(nibName: Constants.TableViewCellID.AppliedLeaveHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableViewCellID.AppliedLeaveHeaderView)
            tableView.register(UINib.init(nibName: Constants.TableViewCellID.AppliedLeavesCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.AppliedLeavesCell)
        }
    }

    lazy var viewModel: LeaveViewModel = {
        return LeaveViewModel()
    }()
    
    var leaveInfo: [Leave] = []
    var isAppliedLeave: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getProfile()
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.leaveInfo.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

    
extension LeaveApplicationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueCell(reuseIdentifier: Constants.TableViewCellID.AppliedLeavesCell, for: indexPath) as! AppliedLeavesTableViewCell
         
            cell.dateLbl.text = leaveInfo[indexPath.row].fromDate
            cell.statusLbl.text = leaveInfo[indexPath.row].isApproved ?? false ? "Approved" : "Pending"
           
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.LeaveStatusVC) as! LeaveStatusViewController
        
        if let approved = leaveInfo[indexPath.row].isApproved {
            vc.isApproved = approved
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewCellID.LeaveHeaderView) as! LeaveApplicationHeaderView
            header.delegate = self
        
            header.applyLeave(leaveData: leaveInfo)
            
            if isAppliedLeave {
                header.titleTextField.text?.removeAll()
                header.fromTextField.text?.removeAll()
                header.toTextField.text?.removeAll()
                header.descriptionTextField.text?.removeAll()
            }
            
            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewCellID.AppliedLeaveHeaderView) as! AppliedLeaveHeaderView
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LeaveApplicationViewController: LeaveDelegate {
    
    func getLeaveInfo(_leaveData: [Leave]) {
        isAppliedLeave = true
        leaveInfo = _leaveData
        tableView.reloadData()
        scrollToBottom()
    }
    
    func successful(message: String) {
        viewModel.getProfile()
        self.displayServerSuccess(withMessage: message)
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension LeaveApplicationViewController: GetLeaveDataDelegate {
  
    
    func leaveData(from: String, to: String, title: String, description: String) {
        
        let request = ApplyLeaveRequest(title: title, description: description, from_date: from, to_date: to)
        viewModel.applyLeave(request: request)
    }
    
}
