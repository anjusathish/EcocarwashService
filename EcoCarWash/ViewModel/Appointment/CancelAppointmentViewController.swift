//
//  CancelAppointmentViewController.swift
//  Eco carwash Service
//
//  Created by Indium Software on 13/01/22.
//

import UIKit

class CancelAppointmentViewController: BaseViewController {

    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeAddressLbl: UILabel!

    var delegate: AssignCleanerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func yesBtn(_ sender: UIButton) {
        delegate.cancelAppointment(isCancelled: true)
    }
    
    @IBAction func noBtn(_ sender: UIButton) {
        delegate.cancelAppointment(isCancelled: false)
    }

}
