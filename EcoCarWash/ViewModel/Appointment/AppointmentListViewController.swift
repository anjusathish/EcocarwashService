//
//  AppointmentListViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 05/01/22.
//

import UIKit

class AppointmentListViewController: BaseViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var orderTableView: UITableView! {
        didSet {
            orderTableView.register(UINib.init(nibName: Constants.TableViewCellID.BookedAppointmentCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.BookedAppointmentCell)
        }
    }

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var listAppointments: [AppointmentData] = []
    var isCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getAppointmentList()
        
        backBtn.setTitle(isCompleted ? " Orders" : " Completed log", for: .normal)
        
    }

    @IBAction func filterBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentDetailVC) as! AppointmentDetailViewController
        vc.orderId = "21"

//        if let id = listAppointments[indexPath.row].id {
//        }

        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension AppointmentListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listAppointments.count == 0 {
            
            tableView.setEmptyView(title: "There are no appointments available!")
            
        }else {
            
            tableView.restore()
        }
        
        return listAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.BookedAppointmentCell, for: indexPath) as! BookedAppointmentCell
        
        let appointmentInfo = listAppointments[indexPath.row]
        
        cell.storeNameLbl.text = appointmentInfo.store?.name
        cell.storeAddressLbl.text = appointmentInfo.store?.address?.address
        cell.completedObLbl.text = appointmentInfo.store?.name
        cell.ratingView.currentRating = Int(appointmentInfo.store?.rating ?? "") ?? 0
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentDetailVC) as! AppointmentDetailViewController

        if let id = listAppointments[indexPath.row].id {
            vc.orderId = "\(id)"
        }

        self.navigationController?.pushViewController(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            if let id = listAppointments[indexPath.row].id {
//                viewModel.deleteAppointmentList(id: "\(id)")
//            }
//        }
//    }

}

extension AppointmentListViewController: AppointmentDelegate {
   
    func getAppointmentList(_data: [AppointmentData]) {
        
        if isCompleted {
            listAppointments = _data.filter({ AppointmentBtnStatus(rawValue: $0.status ?? "") == .Completed })
        } else {
            listAppointments = _data
        }
        
        orderTableView.reloadData()
    }
    
    func getStoreTimingData(_data: TimeData) {
        
    }

    func getServiceListInfo(_data: [ServiceData], message: String) {

    }
    
    func getAppointmentData(_data: AppointmentData) {
        
    }
    
    func successful(message: String) {
        
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}
