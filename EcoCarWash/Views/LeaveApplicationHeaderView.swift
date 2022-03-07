//
//  LeaveApplicationHeaderView.swift
//  Eco Car Wash Drive
//
//  Created by Indium Software on 12/10/21.
//

import UIKit
import TTGSnackbar
import TextFieldFloatingPlaceholder

protocol GetLeaveDataDelegate {
    func leaveData(from: String, to: String, title: String, description: String)
}

class LeaveApplicationHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var descriptionTextField: CTTextField!
    @IBOutlet var applyBtn: UIButton!
    @IBOutlet weak var fromTextField: TextFieldFloatingPlaceholder! {
        didSet {
            fromTextField.floatingPlaceholderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 0.7307429029)
            fromTextField.validationTrueLineColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            fromTextField.validationTrueLineEditingColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBOutlet weak var toTextField: TextFieldFloatingPlaceholder! {
        didSet {
            toTextField.floatingPlaceholderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 0.7307429029)
            toTextField.validationTrueLineColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            toTextField.validationTrueLineEditingColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBOutlet weak var titleTextField: TextFieldFloatingPlaceholder!{
        didSet {
            titleTextField.floatingPlaceholderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 0.7307429029)
            titleTextField.validationTrueLineColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            titleTextField.validationTrueLineEditingColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var delegate: GetLeaveDataDelegate!
    private let snackbar = TTGSnackbar()
    var pendingLeave: [Leave] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        [fromTextField, toTextField].forEach { textField in
            datePicker.datePickerMode = .date
            textField?.inputView = datePicker
            datePicker.minimumDate = Date()
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        datePicker.datePickerMode = .date
        
        if let date = sender?.date {
            if fromTextField.isEditing {
                fromTextField.text = date.getasString(inFormat: "yyyy-MM-dd")
            } else {
                toTextField.text = date.getasString(inFormat: "yyyy-MM-dd")
            }
        }
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }

    func displayError(withMessage message : ErrorMessage) {
        snackbar.duration = .middle
        snackbar.message = message.rawValue
        snackbar.show()
    }

    @IBAction func applyBtn(_ sender: UIButton) {
    
        guard pendingLeave.count > 0 else {
            self.displayError(withMessage: .pendingLeave)
            return
        }

        guard let from = fromTextField.text, from.count != 0 else {
            self.displayError(withMessage: .leaveFromDate)
            return
        }
        
        guard let to = toTextField.text, to.count != 0 else {
            self.displayError(withMessage: .leaveToDate)
            return
        }
        
        guard let title = titleTextField.text, title.count != 0 else {
            self.displayError(withMessage: .leaveTitle)
            return
        }
        
        guard let description = descriptionTextField.text, description.count != 0 else {
            self.displayError(withMessage: .leaveToDescription)
            return
        }

        delegate.leaveData(from: from, to: to, title: title, description: description)
    }
    
    func applyLeave(leaveData: [Leave]) {
        pendingLeave = leaveData.filter({ LeaveStatus(rawValue: $0.status ?? "") == .Pending })
    }
    
}
