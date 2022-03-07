//
//  ForgetPasswordViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 08/09/21.
//

import UIKit
import TextFieldFloatingPlaceholder

protocol ChangePasswordDelegate {
    func changedPassword()
}

class ForgetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var oldPwdTF: TextFieldFloatingPlaceholder!{
        didSet{
            oldPwdTF.changeTFColor()
        }
    }

    @IBOutlet weak var pwdTF: TextFieldFloatingPlaceholder!{
        didSet{
            pwdTF.changeTFColor()
        }
    }
    @IBOutlet weak var confirmPwdTF: TextFieldFloatingPlaceholder!{
        didSet{
            confirmPwdTF.changeTFColor()
        }
    }
    @IBOutlet weak var oldPwdErrLbl: UILabel!
    @IBOutlet weak var pwdErrLbl: UILabel!
    @IBOutlet weak var pwdMatchErrLbl: UILabel!

    var strValue = ""
    var delegate: ChangePasswordDelegate?
    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        
        guard let oldPwd = oldPwdTF.text, checkPwdStatus(text: oldPwd).0, checkPwdStatus(text: oldPwd).1,  checkPwdStatus(text: oldPwd).2 else {
            displayError(withMessage: .invalidPassword)
            return
        }
        
        guard let newPwd = pwdTF.text, checkPwdStatus(text: newPwd).0, checkPwdStatus(text: newPwd).1,  checkPwdStatus(text: newPwd).2 else {
            displayError(withMessage: .invalidPassword)
            return
        }

        guard let confirmPwd = confirmPwdTF.text, checkPwdStatus(text: confirmPwd).0, checkPwdStatus(text: confirmPwd).1,  checkPwdStatus(text: confirmPwd).2 else {
            displayError(withMessage: .invalidPassword)
            return
        }

        guard oldPwd != newPwd else {
            displayError(withMessage: .passwordSameError)
            return
        }
        
        guard newPwd == confirmPwd else {
            displayError(withMessage: .invalidPasswordMismatch)
            return
        }
        
        
      guard let userID = UserManager.shared.currentUser?.uuid else {
          self.displayError(withMessage: .invalidUser)
          return
      }

        let request = ChangePasswordRequest(old_password: oldPwd, new_password: newPwd)
        viewModel.changePassword(userId: userID, request: request)
    }
}

extension ForgetPasswordViewController: ProfileDelegate {
   
    func managerProfileInfo(_info: ProfileData) {
        
    }
    
    func userProfileDetails(data: UserProfileResponse) {
        
    }
    
    func successful(message: String) {
        delegate?.changedPassword()
        self.displayServerSuccess(withMessage: message)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
}

extension ForgetPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
            if textField == oldPwdTF  {
                pwdCheck(lbl: oldPwdErrLbl, string: strValue)
            } else if textField == pwdTF {
                pwdCheck(lbl: pwdErrLbl, string: strValue)
            }
        }
        
        if textField == oldPwdTF  {
            pwdCheck(lbl: oldPwdErrLbl, string: strValue)
        } else if textField == pwdTF {
            pwdCheck(lbl: pwdErrLbl, string: strValue)
        } else if textField == confirmPwdTF {
            pwdMatchErrLbl.isHidden = pwdTF.text == strValue
        }

        return true
    }
}
