//
//  ProfileViewController.swift
//  Eco Car Wash Drive
//
//  Created by Indium Software on 06/10/21.
//

import UIKit

class ProfileViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameTextField: CTTextField!
    @IBOutlet weak var emailTextField: CTTextField!
    @IBOutlet weak var passwordTextField: CTTextField!
    @IBOutlet weak var phoneNoTextField: CTTextField!

    @IBOutlet weak var accountNameTextField: CTTextField!
    @IBOutlet weak var accountNoTextField: CTTextField!
    @IBOutlet weak var accountPhoneTextField: CTTextField!
    @IBOutlet weak var bankNameTextField: CTTextField!
    @IBOutlet weak var ifscCodeTextField: CTTextField!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var bankStackView: UIStackView!

    var imagePicker = UIImagePickerController()
    var image = UIImage()
    var imageUrlString: String = ""
    var bankId: String = ""

    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
        if let user = UserManager.shared.currentUser {
            if let userId = user.uuid {
                viewModel.getProfile(userId: userId)
            }
            
            if let type = user.userType {
                if let userType = UserType(rawValue: type) {
                    switch userType {
                    case .manager:
                        viewModel.getBankDetails()
                        bankStackView.isHidden = false
                        
                    case .cleaner:
                        bankStackView.isHidden = true
                    }
                }
            }
        }
        
        passwordTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.forgetPwdVC) as! ForgetPasswordViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func changeProfileBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
//        alert.addAction(UIAlertAction(title: "View Image", style: .default, handler: { _ in
//            self.openImage()
//        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Open Camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Open Gallary
    func openGallary(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func openImage(){
//        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.openImageVC) as! OpenImageViewController
//        vc.selectedImage = profileImageView.image
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            profileImgVw.image = image
        }
        
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                        
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            imageUrlString = URL(fileURLWithPath: localPath).absoluteString
        } else {
            
            if let pickedImageUrl = info[.imageURL] as? URL {
                imageUrlString = pickedImageUrl.absoluteString
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        updateProfileAPI()
        if let type = UserManager.shared.currentUser?.userType {
            if let userType = UserType(rawValue: type) {
                if userType == .manager {
                    updateBankDetailsAPI()
                }
            }
        }
    }

    func updateProfileAPI() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            self.displayError(withMessage: .invalidName)
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail() else {
            self.displayError(withMessage: .invalidEmail)
            return
        }
        
        guard let mobileNo = phoneNoTextField.text, !mobileNo.isEmpty, mobileNo.count == 10 else {
            self.displayError(withMessage: .invalidMobileNumber)
            return
        }
          
        guard let userID = UserManager.shared.currentUser?.uuid else {
            self.displayError(withMessage: .invalidUser)
            return
        }

        let request = UpdateProfileRequest(name: name, mobile_no: mobileNo, profile_image: imageUrlString)
        viewModel.updateProfile(userId: userID, request: request)
    }
    
    func updateBankDetailsAPI() {
        
        guard let accountHolderName = accountNameTextField.text, !accountHolderName.isEmpty else {
            self.displayError(withMessage: .invalidAccountHolderName)
            return
        }
        
        guard let accountNumber = accountNoTextField.text, !accountNumber.isEmpty else {
            self.displayError(withMessage: .invalidAccountNumber)
            return
        }
        
        guard let ifsc = ifscCodeTextField.text, !ifsc.isEmpty else {
            self.displayError(withMessage: .invalidIFSC)
            return
        }
        
        guard let bankName = bankNameTextField.text, !bankName.isEmpty else {
            self.displayError(withMessage: .invalidBankName)
            return
        }
        
        guard let bankMobileNo = accountPhoneTextField.text, !bankMobileNo.isEmpty, bankMobileNo.count == 10 else {
            self.displayError(withMessage: .invalidMobileNumber)
            return
        }
        
        let request = UpdateBankRequest(account_holder_name: accountHolderName, account_number: accountNumber, ifsc_code: ifsc, bank_name: bankName, mobile_number: bankMobileNo)
        
        viewModel.updateBankDetails(request: request, id: bankId)
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController: ProfileDelegate {
  
    func managerProfileInfo(_info: ProfileData) {
        
        nameTextField.text = _info.name
        emailTextField.text = _info.email
        passwordTextField.text = "********"
        phoneNoTextField.text = _info.mobileNo
        
        if let bankDetails = _info.bankDetails {
            bankId = "\(bankDetails.id ?? 00)"
            accountNameTextField.text = bankDetails.accountHolderName
            accountNoTextField.text = bankDetails.accountNumber
            accountPhoneTextField.text = bankDetails.mobileNumber
            ifscCodeTextField.text = bankDetails.ifscCode
            bankNameTextField.text = bankDetails.bankName
        }

        if let urlString = _info.profileImage, let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
//                profileImgVw.image = UIImage(data: data)
            } else {
                profileImgVw.image = UIImage(named: "profile_avatar")
            }
        }
        MBProgressHUD.hide(for: UIApplication.shared.windows.first!, animated: true)

    }
    
    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
        if let userId = UserManager.shared.currentUser?.uuid {
            viewModel.getProfile(userId: userId)
        }
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension ProfileViewController: ChangePasswordDelegate {
    
    func changedPassword() {
        UserManager.shared.deleteActiveUser()
        if let vc = navigationController?.viewControllers.first(where: { $0 is LoginViewController}) {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}


extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.forgetPwdVC) as! ForgetPasswordViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
