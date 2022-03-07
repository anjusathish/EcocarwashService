//
//  DashboardViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import RESideMenu
import CoreLocation

class DashboardViewController: BaseViewController {

    @IBOutlet weak var activeCountLbl: UILabel!
    @IBOutlet weak var upcomingCountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var activeServiceCollVw: UICollectionView!{
        didSet{
            activeServiceCollVw.register(UINib(nibName: Constants.CollectionViewID.ActiveServiceCell, bundle: .main), forCellWithReuseIdentifier: Constants.CollectionViewID.ActiveServiceCell)
        }
    }
    
    @IBOutlet weak var upcomingServiceCollVw: UICollectionView!{
        didSet{
            upcomingServiceCollVw.register(UINib(nibName: Constants.CollectionViewID.UpcomingServiceCell, bundle: .main), forCellWithReuseIdentifier: Constants.CollectionViewID.UpcomingServiceCell)
        }
    }

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var activeAppointmentData: [AppointmentData] = []
    var upcomingAppointmentData: [AppointmentData] = []
    
    let dbRef = Database.database().reference()
    var firebaseAutoId: String = ""
    
    var locationPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        sideMenuViewController.delegate = self
        viewModel.getAppointmentList(status: .combined)
        nameLbl.text = UserManager.shared.currentUser?.name
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func showSideMenu(_ sender: UIButton) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func appointmentBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.appointmentVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewAllBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentListVC)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func checkCollectionData(data: [AppointmentData], collectionView: UICollectionView) {
        if data.count == 0 {
            collectionView.setEmptyView(title: "There are no appointments available!")
        }else {
            collectionView.restore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == activeServiceCollVw {
            checkCollectionData(data: activeAppointmentData, collectionView: activeServiceCollVw)
        } else {
            checkCollectionData(data: upcomingAppointmentData, collectionView: upcomingServiceCollVw)
        }
        
        let activeCount = activeAppointmentData.count
        let upcomingCount = upcomingAppointmentData.count //< 4 ? upcomingAppointmentData.count : 4

        return collectionView == activeServiceCollVw ? activeCount : upcomingCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == activeServiceCollVw {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewID.ActiveServiceCell, for: indexPath) as! ActiveServicesCollectionViewCell
            
            let activeAppointment = activeAppointmentData[indexPath.item]
            
            cell.nameLbl.text = activeAppointment.customer?.name
            cell.storeNameLbl.text = activeAppointment.store?.name
            cell.storeAddressLbl.text = activeAppointment.store?.address?.address
            cell.statusLbl.text = activeAppointment.status
            cell.paymentModelLbl.text = activeAppointment.paymentType
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewID.UpcomingServiceCell, for: indexPath) as! UpcomingServicesCollectionViewCell
            
            let upcomingAppointment = upcomingAppointmentData[indexPath.item]
            let time = upcomingAppointment.date?.components(separatedBy: "T").last?.components(separatedBy: "Z").first
            
            cell.nameLbl.text = upcomingAppointment.customer?.name
            cell.storeNameLbl.text = time
            cell.storeAddressLbl.text = upcomingAppointment.store?.address?.address
            cell.timeLbl.text = upcomingAppointment.amountPaid
            cell.assignBtn.addTarget(self, action: #selector(assignCleanerBtn(_:)), for: .touchUpInside)
            cell.assignBtn.tag = indexPath.row
            
            return cell
        }
    }
    
    @objc func assignCleanerBtn(_ sender: UIButton) {
        
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == activeServiceCollVw ? 10.0 : 13.0
    }
}

extension DashboardViewController: AppointmentDelegate {
   
    func getAppointmentList(_data: [AppointmentData]) {

        activeAppointmentData = _data.filter({ AppointmentStatus(rawValue: $0.status ?? "") == .active  })
        upcomingAppointmentData = _data.filter({ AppointmentStatus(rawValue: $0.status ?? "") == .upcoming  })
        
        activeCountLbl.text = "\(activeAppointmentData.count)"
        upcomingCountLbl.text = "\(upcomingAppointmentData.count)"

        let appoimentIDs = activeAppointmentData.compactMap({ $0.id }).sorted()
        saveAppointmentOnDB(appointmentIDs: appoimentIDs)
        
        activeServiceCollVw.reloadData()
        upcomingServiceCollVw.reloadData()
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
// #MARK: - SideMenu Delegate Methods
extension DashboardViewController: RESideMenuDelegate {
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        view.roundCorners(corners: .allCorners, radius: 30)
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        view.roundCorners(corners: .allCorners, radius: 0)
    }
}

// MARK: - FIREBASE STUFFS
extension DashboardViewController {
    
    func saveAppointmentOnDB(appointmentIDs: [Int]) {
        
        var coordinate = CLLocationCoordinate2D()
        
        if let location = LocationManager.sharedManager.locationManager.location {
            
            coordinate = location.coordinate
            
        } else {
            LocationManager.sharedManager.locationUpdateBlock = { location, nowTimestamp in
                coordinate = location.coordinate
                LocationManager.sharedManager.locationUpdateBlock = nil
            }
        }
        
        let coordinateDict: [String: Any] = ["latitude" : coordinate.latitude, "longitude": coordinate.longitude]
        
        for appointmentID in appointmentIDs {
            
            var coordinatePath = ""
            
            if let loggedUser = UserManager.shared.currentUser {
                if let userType = loggedUser.userType {
                    if let type = UserType(rawValue: userType) {
                        switch type {
                        case .manager:
                            coordinatePath = "appointments/\(appointmentID)/coordinates"
                            
                        case .cleaner:
                            if let userId = loggedUser.uuid {
                                let middleWare = "\(userId)_\(appointmentID)"
                                coordinatePath = "appointments/\(middleWare)/coordinates"
                            }
                        }
                    }
                }
            }
            dbRef.child(coordinatePath).setValue(coordinateDict)
        }
    }
}
