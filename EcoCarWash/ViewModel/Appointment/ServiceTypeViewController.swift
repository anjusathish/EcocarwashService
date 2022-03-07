//
//  ServiceTypeViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 24/10/21.
//

import UIKit
import BEMCheckBox

class ServiceTypeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib.init(nibName: Constants.TableViewCellID.ServiceTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.ServiceTableViewCell)
        }
    }
    
    @IBOutlet var serviceBtnArray: [IBButtonClass]!
    @IBOutlet var serviceTypeBtnArray: [IBButtonClass]!
        
    @IBOutlet weak var interiorImgVw: UIImageView!
    @IBOutlet weak var exteriorImgVw: UIImageView!
    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var originalServiceList = [ServiceData]()
    var copyServiceList = [ServiceData]()
    var selectedService: [ServiceData] = []

    var isInterior = true
    var isStandard = true

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getServiceList()
        
    }

    @IBAction func serviceTypeAction(_ sender: IBButtonClass) {
        resetServiceTypeButtons()
        sender.backgroundColor = UIColor.cwSecondary
    }

    @IBAction func filterServiceTypeBtn(_ sender: IBButtonClass) {
        
        switch sender.tag {
            
        case 10 : isInterior = true
               
            if isInterior {
                
                filterServiceData(type: .Interior, service: isStandard ? .Standard : .Premium)

            }
            
        case 20 :  isInterior = false
            
            if !isInterior {
                
                filterServiceData(type: .Exterior, service: isStandard ? .Standard : .Premium)

            }

        default : break
            
        }
    }
    
    @IBAction func filterServiceBtn(_ sender: IBButtonClass) {
        
        switch sender.tag {
            
        case 11 : isStandard = true
            
            if isStandard {
                
                filterServiceData(type: isInterior ? .Interior : .Exterior, service: .Standard)

            }

        case 22 : isStandard = false
            
            if !isStandard {
                
                filterServiceData(type: isInterior ? .Interior : .Exterior, service: .Premium)

            }

        default : break
        }
    }
    
    
    func filterServiceData(type: ServiceType, service: ServiceProvide) {
        
        let serviceData = originalServiceList.filter({ ServiceType(rawValue: $0.service?.serviceType ?? "") == type })
        copyServiceList = serviceData.filter({ ServiceProvide(rawValue: $0.service?.serviceNature ?? "") == service })
        
        for (_index, _data) in copyServiceList.enumerated() {
            if let cell = tableView.cellForRow(at: IndexPath(row: _index, section: 1)) as? ServiceTableViewCell {
                if let isEnabled = _data.isEnabled {
                    cell.checkBox.on = isEnabled
                }
            }
        }
        
        let offset: CGFloat = 20.0
        let serviceCount = copyServiceList.count
        tableHeightConstant.constant = serviceCount > 4 ? 160.0 : CGFloat(40 * serviceCount) + offset
        tableView.reloadData()
    }
    
    
    @IBAction func tabBarAction(_ sender: IBButtonClass) {
        resetTabButtons()
        sender.bottomlineColor = UIColor.cwSecondary
    }
    
    func resetTabButtons() {
        
        for btn in self.serviceBtnArray
        {
            btn.bottomlineColor = UIColor.white
        }
        tableView.reloadData()
    }

    func resetServiceTypeButtons() {
        
        for btn in self.serviceTypeBtnArray
        {
            btn.backgroundColor = UIColor.white
        }
        tableView.reloadData()
    }
    
    @objc func checkBoxAction(sender: BEMCheckBox) {
        
        let selectedServiceData = copyServiceList[sender.tag]
        
        if selectedService.contains(where: {$0.id == selectedServiceData.id})
        {
            selectedService.removeAll(where: { $0.id == selectedServiceData.id })
        }
        else
        {
            selectedService.append(selectedServiceData)
        }

        serviceConfig(services: selectedService)
    }
    
    func serviceConfig(services: [ServiceData]) {
        let interiorSelected = services.filter({ ServiceType(rawValue: $0.service?.serviceType ?? "") == .Interior })
        let exteriorSelected = services.filter({ ServiceType(rawValue: $0.service?.serviceType ?? "") == .Exterior })

        interiorImgVw.isHidden = interiorSelected.count == 0
        exteriorImgVw.isHidden = exteriorSelected.count == 0
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        
        let selectedIDs = selectedService.compactMap({ $0.id! })
        let req = ServiceRequest(service_map_ids: selectedIDs)
        
        viewModel.updateServiceList(info: req)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ServiceTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if copyServiceList.count == 0 {
            
            tableView.setEmptyView(title: "There are no services available!")
            
        }else {
            
            tableView.restore()
        }
        
        return copyServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.ServiceTableViewCell, for: indexPath) as! ServiceTableViewCell
        
        let service = copyServiceList[indexPath.row]
        
        if selectedService.contains(where: { $0.id == service.id})
        {
            cell.checkBox.on = true
        }
        else
        {
            cell.checkBox.on = false
        }
        
        cell.checkBox.addTarget(self, action: #selector(checkBoxAction(sender:)), for: .valueChanged)
        cell.checkBox.tag = indexPath.row
        
        cell.serviceTitleLbl.text = copyServiceList[indexPath.row].service?.title
        cell.timeTakenLbl.text = "\(copyServiceList[indexPath.row].service?.timetaken ?? 0) mins"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension ServiceTypeViewController: AppointmentDelegate {
   
    func getServiceListInfo(_data: [ServiceData], message: String) {
        
        let window = UIApplication.shared.windows.first
        MBProgressHUD.hide(for: window!, animated: true)
        
        
        originalServiceList = _data.sorted(by: { $0.service?.title ?? "" < $1.service?.title ?? "" })
        selectedService = originalServiceList.filter({$0.isEnabled ?? false})
        filterServiceData(type: .Interior, service: .Standard)
        serviceConfig(services: selectedService)
        
        if message != "" {
            self.displayServerSuccess(withMessage: message)
        }
    }
    
    func getStoreTimingData(_data: TimeData) {
        
    }

    func successful(message: String) {

    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func getAppointmentList(_data: [AppointmentData]) {
        
    }
    
    func getAppointmentData(_data: AppointmentData) {
        
    }
}
