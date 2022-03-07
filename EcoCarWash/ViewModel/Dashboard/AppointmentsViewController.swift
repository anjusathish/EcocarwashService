//
//  AppointmentsViewController  Appointments  AppointmentsViewController.swift
//  Eco Car Wash Drive
//
//  Created by Indium Software on 01/10/21.
//

import UIKit

class AppointmentsViewController: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var appointmentDateBtn: UIButton!
    @IBOutlet weak var appointmentTblVw: UITableView!{
        didSet {
            appointmentTblVw.register(UINib(nibName: Constants.TableViewCellID.AppointmentTableViewCell, bundle: .main), forCellReuseIdentifier: Constants.TableViewCellID.AppointmentTableViewCell)
        }
    }
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    lazy var monthDateDayInfo: ([String], [String], [String]) = {
        let arr = getMonthDate(date: slotDate)
        return arr
    }()

    var appointmentData: [AppointmentData] = []
    var slotDate = Date()
    var selectedIndexPath: IndexPath?
    var currentDate = Date()
    var selectedDateString: String = Date().asString(withFormat: "yyyy-MM-dd")
    var numberOfDays: Int = 0
    var selectedAppointmentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollDays()
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: UIControl.Event.valueChanged)

        viewModel.delegate = self
        viewModel.getAppointmentListBy(status: .combined, date: selectedDateString)

    }
    
    func scrollDays() {
        if let index = monthDateDayInfo.2.firstIndex(of: selectedDateString) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            selectedIndexPath = indexPath
        }
    }
    
    func getDayCount(date: Date) {
        
        let year = Int(date.asString(withFormat: "yyyy"))
        let month = Int(date.asString(withFormat: "mm"))
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        numberOfDays = range.count
    }

    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        datePicker.datePickerMode = .date
        presentedViewController?.dismiss(animated: true, completion: nil)

        if let selectedDate = sender?.date {
            selectedDateString = selectedDate.asString(withFormat: "yyyy-MM-dd")
            datePicker.date = selectedDateString.getDate(inFormat: "MMMM yyyy")
            
            getDayCount(date: selectedDate)
            monthDateDayInfo = getMonthDate(date: selectedDate)
            viewModel.getAppointmentListBy(status: .combined, date: selectedDateString)
            scrollDays()
            collectionView.reloadData()
        }
    }

    func getMonthDate(date: Date) -> ([String], [String], [String]) {
        
        var _date = [String]()
        var _day = [String]()
        var _dateString = [String]()
        let allDays = date.getAllDays()
        
        for day in allDays {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            _date.append("\(day.asString(withFormat: "dd"))")
            _dateString.append("\(day.asString(withFormat: "yyyy-MM-dd"))")
            _day.append(dateFormatter.string(from: day))
        }
        _date.removeLast()
        _day.removeLast()
        _dateString.removeLast()
        return (_date, _day, _dateString)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if appointmentData.count == 0 {
            tableView.setEmptyView(title: "There are no appointments available \n for the selected date!")
        } else {
            tableView.restore()
        }
        
        return appointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.AppointmentTableViewCell, for: indexPath) as! AppointmentTableViewCell
        
        let appointment = appointmentData[indexPath.row]
        let appointmentTime = appointment.date?.getDate(inFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
       
        cell.timeLbl.text = appointmentTime?.asString(withFormat: "HH:mm")
        cell.nameLbl.text = appointment.customer?.name
        cell.storeNameLbl.text = appointment.store?.name
        cell.storeAddressLbl.text = appointment.store?.address?.address
                
        if let userType = UserManager.shared.currentUser?.userType {
            if let type = UserType(rawValue: userType) {
                switch type {
                case .manager:
                    if let appointmentStatus = appointment.appointmentStatus {
                        if let status = AppointmentBtnStatus(rawValue: appointmentStatus) {
                            switch status {
                            case .Created, .Accepted:
                                cell.acceptBtn.setTitle(status.buttonName, for: .normal)
                                cell.moreBtn.isHidden = false
                                
                            case .Assigned, .Departed, .Reached, .Progress, .Done, .Completed, .Rescheduled:
                                cell.acceptBtn.isHidden = true
                                cell.moreBtn.isHidden = true
                                
                            case .Cancelled:
                                cell.acceptBtn.setTitle(status.buttonName, for: .normal)
                                cell.acceptBtn.isUserInteractionEnabled = false
                                cell.acceptBtn.backgroundColor = UIColor.gray
                                cell.acceptBtn.setTitleColor(.cwBlue, for: .normal)
                                cell.moreBtn.isHidden = true
                            }
                        }
                    }
                case .cleaner:
                    cell.acceptBtn.isHidden = true
                    cell.moreBtn.isHidden = true
                }
            }
        }

        cell.acceptBtn.addTarget(self, action: #selector(acceptBtn(_:)), for: .touchUpInside)
        cell.moreBtn.addTarget(self, action: #selector(moreBtn(_:)), for: .touchUpInside)
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtn(_:)), for: .touchUpInside)
      
        cell.acceptBtn.tag = indexPath.row
        cell.moreBtn.tag = indexPath.row
        cell.cancelBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func acceptBtn(_ sender: UIButton) {
        let appointment = appointmentData[sender.tag]
        selectedAppointmentId = "\(appointment.id ?? 0)"
        
        if sender.title(for: .normal) == "Accept" {
            let request = UpdateAppointmentRequest(cleaner: "", appointment_status: "Accepted", tracking_id: "")
            viewModel.updateAppointment(id: selectedAppointmentId, info: request)
        }
        else if sender.title(for: .normal) == "Assign Cleaner" {
            let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.AvailableCleanerVC) as! AvailableCleanerViewController
            vc.selectedDate = selectedDateString
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func moreBtn(_ sender: UIButton) {
        let appointment = appointmentData[sender.tag]
        selectedAppointmentId = "\(appointment.id ?? 0)"
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = appointmentTblVw.cellForRow(at: indexPath) as? AppointmentTableViewCell {
            cell.cancelBtn.isHidden = !cell.cancelBtn.isHidden
        }
    }
    
    @objc func cancelBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = appointmentTblVw.cellForRow(at: indexPath) as? AppointmentTableViewCell {
            cell.cancelBtn.isHidden = true
        }

        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.CancelAppointmentVC) as! CancelAppointmentViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AppointmentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthDateDayInfo.0.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppointmentDateCollectionCell", for: indexPath) as! AppointmentDateCollectionCell
        
        cell.dayLbl.text = monthDateDayInfo.1[indexPath.item]
        cell.dateLbl.text = monthDateDayInfo.0[indexPath.item]

        if indexPath == selectedIndexPath {
            cell.selected()
        } else {
            cell.unSelected()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppointmentDateCollectionCell", for: indexPath) as! AppointmentDateCollectionCell

        cell.dayLbl.backgroundColor = UIColor.cwSecondary
        cell.dayLbl.textColor = UIColor.cwBlue
        
        makeCellSelected(in: collectionView, on: indexPath)
        selectedIndexPath = indexPath
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()

        viewModel.getAppointmentListBy(status: .combined, date: monthDateDayInfo.2[indexPath.item])

        let window = UIApplication.shared.windows.first
        
        MBProgressHUD.showAdded(to: window!, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.appointmentTblVw.reloadData()
            MBProgressHUD.hide(for: window!, animated: true)
        }
    }
    
    func makeCellSelected(in collectionView: UICollectionView, on indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AppointmentDateCollectionCell {
            cell.selected()
        }
    }

    func makeCellUnSelected(in tableView: UICollectionView, on indexPath: IndexPath) {
        if let cell = tableView.cellForItem(at: indexPath) as? AppointmentDateCollectionCell {
            cell.unSelected()
        }
    }

}

extension AppointmentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 80.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


class AppointmentDateCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!

    func selected() {
        view.backgroundColor = UIColor.cwSecondary
        dayLbl.textColor =  UIColor.cwBlue
        dateLbl.textColor =  UIColor.cwBlue
    }

    func unSelected() {
        view.backgroundColor = UIColor.cwBlue
        dayLbl.textColor =  UIColor.white
        dateLbl.textColor =  UIColor.white
    }
    
}

extension AppointmentsViewController: AppointmentDelegate {
   
    func getAppointmentList(_data: [AppointmentData]) {

        appointmentData = _data.filter({ AppointmentStatus(rawValue: $0.status ?? "") == .active  })
        appointmentTblVw.reloadData()
    }
    
    func getStoreTimingData(_data: TimeData) {
        
    }

    func getServiceListInfo(_data: [ServiceData], message: String) {

    }
    
    func getAppointmentData(_data: AppointmentData) {
        
    }
    
    func successful(message: String) {
        viewModel.getAppointmentListBy(status: .combined, date: selectedDateString)
        self.dismiss(animated: true, completion: nil)
        self.displayServerSuccess(withMessage: message)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension AppointmentsViewController: AssignCleanerDelegate {
   
    func assignCleaner(userId: String) {
        let request = UpdateAppointmentRequest(cleaner: userId, appointment_status: "Cleaner_Assigned", tracking_id: "")
        viewModel.updateAppointment(id: selectedAppointmentId, info: request)
    }
    
    func cancelAppointment(isCancelled: Bool) {
        if isCancelled {
            let request = UpdateAppointmentRequest(cleaner: "", appointment_status: "Cancelled", tracking_id: "")
            viewModel.updateAppointment(id: selectedAppointmentId, info: request)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

