//
//  AppointmentDetailViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 06/01/22.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class AppointmentDetailViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var carMakeLbl: UILabel!
    @IBOutlet weak var carModelLbl: UILabel!
    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var serviceStatusImgVw: UIImageView!
    @IBOutlet weak var serviceModeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var paymentModeLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cleanerNameLbl: UILabel!
    @IBOutlet weak var cleanerImgVw: UIImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var userRatingImgVw: UIImageView!
    @IBOutlet weak var userNameRatingLbl: UILabel!
    @IBOutlet weak var ratingDescriptionLbl: UILabel!
    @IBOutlet weak var carImgCollectionView: UICollectionView!
    @IBOutlet weak var appointmentStackView: UIStackView!
    @IBOutlet weak var carWashProgressView: UIView!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var couponDottedBorderVw: UIView! {
        didSet {
            couponDottedBorderVw.addDashedBorder()
        }
    }
    @IBOutlet weak var serviceTblVw: UITableView! {
        didSet {
            serviceTblVw.register(UINib(nibName: Constants.TableViewCellID.ServiceTypeHeaderCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableViewCellID.ServiceTypeHeaderCell)
        }
    }
    
    var orderId: String = ""
    var appointmentInfo: AppointmentData?
    var headerData: [(String, String)] = []
    var headerCarImageData: [String] = []
    var overallService: [[Service]] = []
    var appointmentRatingInfo: AppointmentRating?
    var appointmentImageInfo: [[AppointmentImage]] = []
    var imagePicker = UIImagePickerController()
    var image = UIImage()
    var imageUrlString: String = ""
    lazy var viewModel: AppointmentViewModel = {
       return AppointmentViewModel()
    }()
    
    var locationPath: String = ""
    let dbRef = Database.database().reference()
    var customerLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getAppointment(id: orderId)
        
        if let user = UserManager.shared.currentUser {
            if let type = user.userType {
                appointmentStackView.isHidden = UserType(rawValue: type) == .cleaner
                carWashProgressView.isHidden = UserType(rawValue: type) == .manager
            }
        }
    }
    
    func getServiceData(service: [Service]) {
        
        let interiorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Interior })
        let exteriorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Exterior })
        
        overallService.append(interiorData)
        overallService.append(exteriorData)
                    
        _ = overallService.map({ serviceArr in
            
            if let type = serviceArr.first?.serviceType, let nature = serviceArr.first?.serviceNature {
                headerData.append((type, nature))
            }
        })
        
        let offset: CGFloat = headerData.count == 2 ? 80.0 : 40.0
        let serviceCount = Int(interiorData.count) + Int(exteriorData.count)
        
        tableHeightConstant.constant = CGFloat(30 * serviceCount) + offset
        serviceTblVw.reloadData()
    }
    
    func getCarImageData(appointmentImg: [AppointmentImage]) {
        
        let beforeData = appointmentImg.filter({ $0.imageType == "Before" })
        let afterData = appointmentImg.filter({ $0.imageType == "After" })
        
        appointmentImageInfo.append(beforeData)
        appointmentImageInfo.append(afterData)
                    
        _ = appointmentImageInfo.map({ carImgArr in
            
            if let imageType = carImgArr.first?.imageType {
                headerCarImageData.append(imageType)
            }
        })
                
        let offset: CGFloat = 20.0
        let imageCount = appointmentImageInfo.count

        let total = Int(appointmentImageInfo.first?.count ?? 0) + Int(appointmentImageInfo.last?.count ?? 0)
        
        collectionHeightConst.constant = total == 0 ? 5 : CGFloat(130 * imageCount) + offset
        carImgCollectionView.reloadData()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func calculatePercentage(value:Double, percentageVal: Double) -> Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    @IBAction func checkStatusBtn(_ sender: UIButton) {
     
        if sender.title(for: .normal) == "Navigate" {
            
            LocationManager.sharedManager.locationUpdateBlock = { location, nowTimestamp in
                
                let coordinate = location.coordinate
                let coordinateDict: [String: Any] = ["latitude" : coordinate.latitude,
                                                     "longitude": coordinate.longitude]
                
                if let loggedUser = UserManager.shared.currentUser {
                    if let userId = loggedUser.uuid {
                        let middleWare = "\(userId)_\(self.orderId)"
                        let coordinatePath = "appointments/\(middleWare)/coordinates"
                        self.dbRef.child(coordinatePath).setValue(coordinateDict)
                        
                        let request = UpdateAppointmentRequest(cleaner: userId,
                                                               appointment_status: "Cleaner_Departed",
                                                               tracking_id: middleWare)
                        
                        self.viewModel.updateAppointment(id: self.orderId, info: request)
                    }
                }
                
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.open(URL(string: "http://maps.google.com/?saddr=\(coordinate.latitude),\(coordinate.latitude)&daddr=\(self.customerLocation.latitude),\(self.customerLocation.longitude)")!, options: [:], completionHandler: nil)
                    sender.isUserInteractionEnabled = false
                } else {
                    sender.isUserInteractionEnabled = true
                    self.displayServerSuccess(withMessage: "Google map is not available!")
                    if let url = URL(string: "https://apps.apple.com/in/app/google-maps-transit-food/id585027354") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } else {
            /// other button names should handle here
        }
    }
    
    func uploadImage() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            self.image = image
        }

        if (picker.sourceType == UIImagePickerController.SourceType.camera) {

            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)

            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true )
            uploadImage(imageString: URL(fileURLWithPath: localPath).absoluteString)
        } else {

            if let pickedImageUrl = info[.imageURL] as? URL {
                uploadImage(imageString: pickedImageUrl.absoluteString)
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(imageString: String) {
        let req = UploadImageRequest(image: imageString, appointment: Int(orderId) ?? 0, image_type: "Before")
        viewModel.updateAppointmentImage(info: req)
    }
    
}

// MARK: - Tableview methods
extension AppointmentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if headerData.count == 0 {
            tableView.setEmptyView(title: "There are no services available!")
        }
        else
        {
            tableView.restore()
        }

        return headerData.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallService[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(reuseIdentifier: Constants.TableViewCellID.ServiceCell, for: indexPath) as! ServiceCell
        cell.serviceNameLbl.text = overallService[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewCellID.ServiceTypeHeaderCell) as! ServiceTypeHeaderCell
        
        header.serviceTypeLbl.text = headerData[section].0
        header.serviceTypeNature.text = headerData[section].1

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}


extension AppointmentDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerCarImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentImageInfo[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewID.CarImageCollectionCell, for: indexPath) as! CarImageCollectionCell
        
        cell.headerLbl.isHidden = indexPath.row != 0
        cell.headerLbl.text = headerCarImageData[indexPath.section]
        
        if let urlString = appointmentImageInfo[indexPath.section][indexPath.item].image,
           let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            cell.carImgVw.image = UIImage(data: data)
        }
        return cell
    }
}

// MARK: - Appointment Delegate
extension AppointmentDetailViewController: AppointmentDelegate {
    
    func getAppointmentData(_data: AppointmentData) {
        let appointment = _data
        appointmentInfo = appointment

        customerNameLbl.text = appointment.customer?.name
        carMakeLbl.text = appointment.userCar?.carMake
        carModelLbl.text = appointment.userCar?.carModel
        carTypeLbl.text = appointment.userCar?.carType
        serviceModeLbl.text = appointment.appointmentNature

        let paidAmount = Double(appointment.amountPaid ?? "") ?? 0.0

        if let coupon = appointment.appliedCoupon {
            couponDottedBorderVw.isHidden = false
            
            let discount = Double(coupon.discountAmount ?? "") ?? 0.0
            let finalPrice = calculatePercentage(value: paidAmount, percentageVal: discount)
            
            discountLbl.text = "₹\(Int(discount)) Off"
            priceLbl.text = "₹\(finalPrice)/-"
        }
        else
        {
            couponDottedBorderVw.isHidden = true
            priceLbl.text = "₹\(paidAmount)/-"
        }
        
        paymentModeLbl.text = appointment.paymentType
        paymentStatusLbl.text = appointment.paymentStatus

        if let _service = appointment.services {
            getServiceData(service: _service)
        }
        
        if let _carImgData = appointment.appointmentImages {
            getCarImageData(appointmentImg: _carImgData)
        }
        
        if let rating = appointment.appointmentRating {
            ratingView.currentRating = rating.rating ?? 0
            ratingDescriptionLbl.text =  rating.review
            
            if let user = UserManager.shared.currentUser {
                userNameRatingLbl.text = user.name
                if let urlString = user.profileImage, let url = URL(string: urlString) {
//                    userRatingImgVw.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
                }
            }
        }
        
        if let location = appointment.address {
            customerLocation = CLLocationCoordinate2D(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0)
        }
    }
    
    func getStoreTimingData(_data: TimeData) {
        
    }

    func getServiceListInfo(_data: [ServiceData], message: String) {

    }
    
    func getAppointmentList(_data: [AppointmentData]) {
        
    }

    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}


class ServiceCell: UITableViewCell {
    @IBOutlet weak var serviceNameLbl: UILabel!
}

class CarImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var carImgVw: UIImageView!
}
