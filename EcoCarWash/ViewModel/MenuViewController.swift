//
//  MenuViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 08/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
//    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var slidemenuTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileBtn: UIButton!

    var menuItemsArr = [String]()
    var menuImgArr = [String]()

    var vc : UIViewController!
    
    var profileFirstName : String?
    var profileLastName : String?
    var profileImage : UIImage?
    
    
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slidemenuTableView.register(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SlideMenuTableViewCell")
        
        self.slidemenuTableView.backgroundColor = UIColor.clear
        
        self.slideMenu()
        self.profileName()
        slidemenuTableView.reloadData()
        
    }
    
    func slideMenu() {
        
        if let userType = UserManager.shared.currentUser?.userType {
            if let type = UserType(rawValue: userType) {
                switch type {
                case .manager:
                    
                    menuItemsArr = ["Orders", "Garage orders" ,"Cleaner", "Configuration","Settings", "Leave", "Completed orders", "Locate store", "Logout"]
                    menuImgArr   = ["Orders", "Orders" ,"Cleaner", "Configuration","Settings", "Leave", "Completed_Orders", "Locate_Store", "Logout"]
                    
                case .cleaner:
                    
                    menuItemsArr = ["Your orders", "Garage orders" ,"Settings", "Leave", "Completed orders", "Logout"]
                    menuImgArr   = ["Orders", "Orders" ,"Settings", "Leave", "Completed_Orders", "Logout"]
                }
            }
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.sideMenuViewController.setContentViewController(UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier: "ProfileVC"), animated: true)
        self.sideMenuViewController.hideViewController()
    }

    func profileName(){
        if let userName = UserManager.shared.currentUser?.name {
            nameLabel.text = userName
        }
        if let email = UserManager.shared.currentUser?.email {
            emailLabel.text = email
        }
        if let img = UserManager.shared.currentUser?.profileImage {
            if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: urlString) {
//                    profileBtn.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
                }
            }

        }
    }
    
    private func alert() {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            UserManager.shared.deleteActiveUser()
            let viewController = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.loginVC)
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = navController
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func profileBtn(_ sender: UIButton) {
        self.sideMenuViewController.hideViewController()

        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.profileVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuTableViewCell", for: indexPath) as! SlideMenuTableViewCell
        
        cell.labelMenu.text = menuItemsArr[indexPath.row]
        
        let menuIcon = menuImgArr[indexPath.row]
        cell.imgMenu.image = UIImage.init(named: menuIcon)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if selectedIndex == indexPath.row{
            cell.labelMenu.textColor = UIColor.white
            cell.imgMenu.tintColor = UIColor.white
        }else{
            cell.labelMenu.textColor = UIColor.white
            cell.imgMenu.tintColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.slidemenuTableView.reloadData()
        
        if let user = UserManager.shared.currentUser?.userType {
            if let type = UserType(rawValue: user) {
                switch type {
                case .manager:
                    self.managerModule()
                case .cleaner:
                    self.cleanerModule()
                }
            }
        }
    }
    
    func cleanerModule() {
        switch selectedIndex {
        case 0:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentListVC)
            (vc as? AppointmentListViewController)?.isCompleted = false
            navigationController?.pushViewController(vc, animated: true)
        case 1: break
        case 2:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.profileVC)
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.leaveApplicationVC)
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentListVC)
            (vc as? AppointmentListViewController)?.isCompleted = true
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.dashboardVC)
            self.sideMenuViewController.setContentViewController(vc, animated: true)
            self.alert()
        default : break
        }
        
        self.sideMenuViewController.hideViewController()
    }
    
    func managerModule() {
        switch selectedIndex {
        case 0:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentListVC)
            (vc as? AppointmentListViewController)?.isCompleted = false
            navigationController?.pushViewController(vc, animated: true)
        case 1: break
        case 2:
            vc = Utilities.sharedInstance.cleanerController(identifier: Constants.StoryboardIdentifier.cleanerListVC)
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.ServiceConfigurationVC)
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.profileVC)
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.leaveApplicationVC)
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.AppointmentListVC)
            (vc as? AppointmentListViewController)?.isCompleted = true
            navigationController?.pushViewController(vc, animated: true)
        case 7: break
        case 8:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.dashboardVC)
            self.sideMenuViewController.setContentViewController(vc, animated: true)
            self.alert()
        default : break
        }
        
        self.sideMenuViewController.hideViewController()
    }
}

