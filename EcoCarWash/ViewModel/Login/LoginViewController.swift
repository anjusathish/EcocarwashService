//
//  LoginViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 03/09/21.
//

import UIKit
import TextFieldFloatingPlaceholder

class LoginViewController: BaseViewController {

    @IBOutlet weak var pwdErrLbl: UILabel!
    @IBOutlet weak var emailTF: TextFieldFloatingPlaceholder! {
        didSet{
            emailTF.changeTFColor()
        }
    }
    @IBOutlet weak var passwordTF: TextFieldFloatingPlaceholder!{
        didSet{
            passwordTF.changeTFColor()
        }
    }

    var strValue = ""
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        emailTF.text = "man_1@gmail.com"
        passwordTF.text = "123456"
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        guard let email = emailTF.text, email.isValidEmail() else {
            displayError(withMessage: .invalidEmail)
            return
        }

        guard let password = passwordTF.text else {
            displayError(withMessage: .invalidPassword)
            return
        }

        viewModel.loginUser(email: email, password: password)
    }
    
    @IBAction func forgetPwdBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.forgetPwdVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.signUpVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: LoginDelegate {
    func loginSuccessfull(message: String) {
        
        
        
        
        self.displayServerSuccess(withMessage: message)
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.rootVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginFailed(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension  LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
            if textField == passwordTF {
                pwdCheck(lbl: pwdErrLbl, string: strValue)
            }
        }
        
        if textField == passwordTF {
            pwdCheck(lbl: pwdErrLbl, string: strValue)
        }
        return true
    }
}
