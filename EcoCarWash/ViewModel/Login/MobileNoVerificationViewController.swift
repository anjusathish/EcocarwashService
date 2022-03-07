//
//  MobileNoVerificationViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 11/09/21.
//

import UIKit

class MobileNoVerificationViewController: UIViewController {

    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var optStaclView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet var otpCollection: [UITextField]!

    var count = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpCollection.forEach { tf in
            tf.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }

    @objc func update() {
        if(count > 0) {
            count -= 1
            countDownLabel.text = "0:\(count)"
        }
    }

    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.count ?? 0 >= 1{
            switch textField{
            case otpCollection[0]: otpCollection[1].becomeFirstResponder()
            case otpCollection[1]: otpCollection[2].becomeFirstResponder()
            case otpCollection[2]: otpCollection[3].becomeFirstResponder()
            case otpCollection[3]: otpCollection[4].becomeFirstResponder()
            case otpCollection[4]: otpCollection[4].resignFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }

    @IBAction func submitBtn(_ sender: UIButton) {
        optStaclView.isHidden = false
        sender.setTitle("Submit & create account", for: .normal)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MobileNoVerificationViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
