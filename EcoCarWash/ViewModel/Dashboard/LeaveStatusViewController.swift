//
//  LeaveStatusViewController.swift
//  Eco Car Wash Drive
//
//  Created by Indium Software on 12/10/21.
//

import UIKit

class LeaveStatusViewController: UIViewController {

    @IBOutlet weak var statusImgVw: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!

    lazy var isApproved = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLbl.text =  isApproved ? LeaveStatus.Approved.text : LeaveStatus.Pending.text
        statusImgVw.image = isApproved ? #imageLiteral(resourceName: "leave-approved") : #imageLiteral(resourceName: "leave-pending")
    }
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


enum LeaveStatus: String {
    case Pending = "pending"
    case Approved = "approved"
    
    var text: String {
        switch self {
        case .Pending  : return "Your leave application is pending"
        case .Approved : return "Your leave application has been approved"
        }
    }
}
