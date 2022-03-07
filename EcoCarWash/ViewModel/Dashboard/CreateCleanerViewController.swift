//
//  CreateCleanerViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 30/12/21.
//

import UIKit

class CreateCleanerViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameTF: CTTextField!
    @IBOutlet weak var emailTF: CTTextField!
    @IBOutlet weak var passwordTF: CTTextField!
    @IBOutlet weak var phoneNoTF: CTTextField!
    @IBOutlet weak var joiningDateTF: CTTextField!
    @IBOutlet weak var docuemntNameLbl: UILabel!

    lazy var viewModel: CleanerViewModel = {
        return CleanerViewModel()
    }()
    var imagePicker = UIImagePickerController()
    var image = UIImage()
    var imageUrlString: String = "No Document"
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }
    
    @IBAction func uploadDocumentBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Document from", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.image = image
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
        
        docuemntNameLbl.text = imageUrlString
        picker.dismiss(animated: true, completion: nil)
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

    @IBAction func createBtn(_ sender: UIButton) {
        
        guard let name = nameTF.text, !name.isEmpty else {
            self.displayError(withMessage: .invalidName)
            return
        }
        
        guard let email = emailTF.text, email.isValidEmail() else {
            self.displayError(withMessage: .invalidEmail)
            return
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            self.displayError(withMessage: .invalidPassword)
            return
        }

        guard let mobileNo = phoneNoTF.text, !mobileNo.isEmpty, mobileNo.count == 10 else {
            self.displayError(withMessage: .invalidMobileNumber)
            return
        }
          
        
        let request = CleanerRequest(name: name, email: email, mobile_no: mobileNo, document: imageUrlString)
        viewModel.createCleaner(request: request)
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateCleanerViewController: CleanerDelegate {
   
    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
        self.navigationController?.popViewController(animated: true)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func getCleanerList(_cleanerListInfo: [Cleaner]) {
        
    }
}

extension CreateCleanerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == joiningDateTF {
            textField.resignFirstResponder()
            textField.text = Date().asString(withFormat: "yyyy-MM-dd")
            datePicker = UIDatePicker()
            
            datePicker.datePickerMode = .date
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.preferredDatePickerStyle = .inline
            datePicker.backgroundColor = UIColor.white
            
            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(datePicker)
            
            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            toolBar.sizeToFit()
            self.view.addSubview(toolBar)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        if let date = sender?.date {
            joiningDateTF.text = date.asString(withFormat: "yyyy-MM-dd")
        }
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
}
