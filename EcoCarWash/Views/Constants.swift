//
//  Constants.swift
//  iJob
//
//  Created by Athiban Ragunathan on 07/01/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

struct REGEX {
    static let phone_indian = "^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$"
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let phone_aus = "([(0),(+61)][23478]){0,1}[1-9][0-9]{7}"
  
}

struct AppFontName {
    static let regular = "BwSurcoDEMO-Regular"
    static let bold = "BwSurcoDEMO-Bold"
    static let semiBold = "BwSurcoDEMO-Medium"
    static let italic = "CourierNewPS-ItalicMT"
}

enum GrantType : String {
    case password = "password"
    case refreshToken = "refresh_token"
}

struct API {
    
    static let scope = "api1 offline_access"
    static let clientId = "ro.angular"
    static let clientSecret = "secret"
    static let baseURL = "122.164.11.112"
    static let scheme = "http"
    static let port = 15000
    static let auth = "/auth/"
    static let path = "/staff/"
}

struct ImageURL {
    static let imageBasePath = "https://app.kindercare.colanonline.in/public/uploads/user/thumb/" // Need to check
}

extension API {
    
    static var fullBaseUrl : String {
        get {
            return API.scheme + "://" + API.baseURL
        }
    }
}

struct GOOGLE {
    static let placesAPI_KEY = "AIzaSyBqOCrPjA9IXTn8pHiNozi6cWI91oIetG0"
}

struct DEVICE {
    static let deviceType = "2"
   // static let uuid = KeychainManager.sharedInstance.getDeviceIdentifierFromKeychain()
    static let deviceModel = UIDevice.current.model
    static let systemVersion = UIDevice.current.systemVersion
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNo = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "100"
}


class Constants: NSObject {
    static let shared = Constants()
    static let appDelegateRef : AppDelegate = AppDelegate.getAppdelegateInstance()!
    static var LAST_SELECTED_INDEX_N_PICKER = 0
    
    struct StoryboardIdentifier {
        static let rootVC       = "RootViewController"
        static let loginVC      = "LoginViewController"
        static let dashboardVC        = "DashboardViewController"
        static let leftMenuVC   = "leftMenuViewController"
        static let forgetPwdVC  = "ForgetPasswordViewController"
        static let signUpVC     = "SignUpViewController"
        static let selectYourCarVC = "SelectYourCarViewController"
        static let mobNoVerificationVC = "MobileNoVerificationViewController"
        static let appointmentVC = "AppointmentsViewController"
        static let profileVC = "ProfileViewController"
        static let leaveApplicationVC = "LeaveApplicationViewController"
        static let LeaveStatusVC = "LeaveStatusViewController"
        static let cleanerListVC = "CleanerListViewController"
        static let createCleanerVC = "CreateCleanerViewController"
        static let AppointmentListVC = "AppointmentListViewController"
        static let AppointmentDetailVC = "AppointmentDetailViewController"
        static let ServiceConfigurationVC = "ServiceConfigurationViewController"
        static let ServiceTimingVC = "ServiceTimingViewController"
        static let ServiceTypeVC = "ServiceTypeViewController"
        static let AvailableCleanerVC = "AvailableCleanerViewController"
        static let CancelAppointmentVC = "CancelAppointmentViewController"
    }
    
    struct TableViewCellID {
        static let AppliedLeavesCell   = "AppliedLeavesTableViewCell"
        static let LeaveHeaderView     = "LeaveApplicationHeaderView"
        static let AppliedLeaveHeaderView = "AppliedLeaveHeaderView"
        static let CleanerCell = "CleanerCell"
        static let BookedAppointmentCell = "BookedAppointmentCell"
        static let ServiceTypeHeaderCell = "ServiceTypeHeaderCell"
        static let ServiceCell = "ServiceCell"
        static let ServiceTableViewCell = "ServiceTableViewCell"
        static let AppointmentTableViewCell = "AppointmentTableViewCell"
    }
    
    struct CollectionViewID {
        static let CarImageCollectionCell   = "CarImageCollectionCell"
        static let ActiveServiceCell = "ActiveServicesCollectionViewCell"
        static let UpcomingServiceCell = "UpcomingServicesCollectionViewCell"
    }

    
    // Custom Date Picker
    class func viewControllerWithName(identifier: String) ->UIViewController {
           let storyboard = UIStoryboard(name: "Leave", bundle: nil)
           return storyboard.instantiateViewController(withIdentifier: identifier)
       }
    
//     func getCustomPickerInstance() -> CustomPicker{
//        let customPickerObj =   Constants.viewControllerWithName(identifier:"CustomPickerStoryboard") as! CustomPicker
//           return customPickerObj
//    }
    
//    func getFilterInstance() -> FilterVC{
//        let filterObj = Constants.viewControllerWithName(identifier:"FilterVC") as! FilterVC
//           return filterObj
//    }
//    func getLeaveFilterInstance() -> LeaveApprovalFilterViewController{
//        let filterObj = Constants.viewControllerWithName(identifier:"LeaveApprovalFilterViewController") as! LeaveApprovalFilterViewController
//           return filterObj
//    }
}

func showAlertView(title: String, msg: String, controller: UIViewController, okClicked: @escaping ()->()){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("OK")
            okClicked()
        }
        //alertController.view.tintColor = BASECOLOR
        alertController.addAction(okAction);
        controller.present(alertController, animated: true, completion: nil)
}

enum AppointmentNature {
    case Store, Mobile, None
}

enum AppointmentType {
    case Normal, RAC
}

enum PaymentType {
    case Credit, Debit, Cash_On_Delivery, UPI, None
}

enum PaymentStatus {
    case Paid, Unpaid, None
}

enum ServiceType: String {
    case Interior = "Interior",
         Exterior = "Exterior"
}

enum ServiceProvide: String {
    case Standard = "Standard",
         Premium  = "Premium"
}

enum Meridiem {
    case Am, Pm
}

enum AppointmentBtnStatus: String {
    
    case Created     = "Created"
    case Accepted    = "Accepted"
    case Assigned    = "Cleaner_Assigned"
    case Departed    = "Cleaner_Departed"
    case Reached     = "Cleaner_Reached"
    case Progress    = "Cleaning_In_Progress"
    case Done        = "Cleaning_Done"
    case Completed   = "Completed"
    case Cancelled   = "Cancelled"
    case Rescheduled = "Rescheduled"
    
    var buttonName: String {
        switch self {
        case .Created    : return "Accept"
        case .Accepted   : return "Assign Cleaner"
        case .Assigned   : return ""
        case .Departed   : return ""
        case .Reached    : return ""
        case .Progress   : return ""
        case .Done       : return ""
        case .Completed  : return ""
        case .Cancelled  : return "Cancelled"
        case .Rescheduled: return ""
        }
    }
}

enum AppointmentStatus: String {
    case active = "active"
    case upcoming = "upcoming"
    case combined = "combined"
}

enum UserType : Int {
    case manager = 2
    case cleaner = 3
}
