//
//  ServiceTimingViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 09/01/22.
//

import UIKit
import BEMCheckBox

class ServiceTimingViewController: BaseViewController {

    @IBOutlet weak var startTimeTF: CTTextField!
    @IBOutlet weak var endTimeTF: CTTextField!
    @IBOutlet weak var pickerContainer: UIViewIBDesignable!
    @IBOutlet weak var timePicker: UIPickerView!{
        didSet {
            timePicker.dataSource = self
            timePicker.delegate = self
        }
    }

    var hours   : [String] = []
    var minutes : [String] = []
    var storeId: Int?
    var h: String = "00"
    var m: String = "00"
    let width: CGFloat = 60.0
    let height: CGFloat = 60.0
    var isStartEditing: Bool = false

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...24 {
            hours.append(String(format: "%02d", i))
        }

        for i in 0...59 {
            minutes.append(String(format: "%02d", i))
        }

        startTimeTF.becomeFirstResponder()
        startTimeTF.inputView = UIView()
        endTimeTF.inputView = UIView()
        startTimeTF.inputAccessoryView = UIView()
        endTimeTF.inputAccessoryView = UIView()

        viewModel.delegate = self
        viewModel.getStoreTiming()
        
    }

    @IBAction func updateTiming(_ sender: UIButton) {
        
        guard let startTime = startTimeTF.text, !startTime.isEmpty else {
            self.displayError(withMessage: .invalidStoreTime)
            return
        }
        
        guard let endTime = endTimeTF.text, !endTime.isEmpty else {
            self.displayError(withMessage: .invalidStoreTime)
            return
        }
        
        if let id = storeId {
            let req = TimingRequest(start_time: startTime, end_time: endTime)
            viewModel.updateStoreTiming(id: "\(id)", info: req)
        }
    }
    
}

extension ServiceTimingViewController: AppointmentDelegate {
   
    func getStoreTimingData(_data: TimeData) {
        if let id = _data.id {
            storeId = id
            startTimeTF.text = _data.startTime
            endTimeTF.text = _data.endTime
        }
    }

    func getAppointmentList(_data: [AppointmentData]) {
        
    }
    
    func getAppointmentData(_data: AppointmentData) {
        
    }
    
    func getServiceListInfo(_data: [ServiceData], message: String) {
        
    }
    
    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension ServiceTimingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1: return 1
        case 2: return minutes.count
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return height
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
            pickerLabel?.textAlignment = .center
        }
        
        switch component {
        case 0: pickerLabel?.text = hours[row]
        case 1: pickerLabel?.text = ":"
        case 2: pickerLabel?.text = minutes[row]
        default: break
        }
       
        pickerLabel?.textColor = UIColor.white
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:  h = hours[row]
        case 2:  m = minutes[row]
        default: break
        }

        let selectedTime = h + ":" + m + ":00"

        if isStartEditing {
            startTimeTF.text = selectedTime
        } else {
            endTimeTF.text = selectedTime
        }
    }
}

extension ServiceTimingViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isStartEditing = textField == startTimeTF
        return true
    }
}
