//
//  CleanerCell.swift
//  Eco carwash Service
//
//  Created by Indium Software on 29/12/21.
//

import UIKit

class CleanerCell: UITableViewCell {

    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var profileStatusDotView: UIView!
    @IBOutlet weak var statusDotView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var leaveTitleLbl: UILabel!
    @IBOutlet weak var leaveDescriptionLbl: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var cleanerProfileStackVw: UIStackView!
    @IBOutlet weak var ratingStackVw: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var leaveApplicationStackVw: UIStackView!
    @IBOutlet weak var cleanerDetailsStackVw: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func expand() {
        self.cleanerDetailsStackVw.isHidden = false
        self.profileStatusDotView.isHidden = false

        self.ratingStackVw.isHidden = true
        self.statusStackView.isHidden = true

        UIView.animate(withDuration: 0.45, delay: 0.0, animations: {
            self.cleanerProfileStackVw.axis = .vertical
        })
    }
    
    func collapse() {
        self.cleanerDetailsStackVw.isHidden = true
        self.profileStatusDotView.isHidden = true
        
        self.ratingStackVw.isHidden = false
        self.statusStackView.isHidden = false

        UIView.animate(withDuration: 0.45, delay: 0.0, animations: {
            self.cleanerProfileStackVw.axis = .horizontal
        })
    }
    
    func configureCell(data: Cleaner) {
        nameLbl.text = data.name
        emailLbl.text = data.email
        phoneLbl.text = data.mobileNo
        statusLbl.text = data.userLeave?.status
        ratingView.currentRating = Int(data.rating ?? "") ?? 0
        
        statusDotView.backgroundColor = CleanerStatus(rawValue: data.userLeave?.status ?? "")?.color
        profileStatusDotView.backgroundColor = CleanerStatus(rawValue: data.userLeave?.status ?? "")?.color
        
        
        if let leave = data.userLeave, let status = leave.status {
            if let cleanerStatus = CleanerStatus(rawValue: status) {
                switch cleanerStatus {
                case .Available, .Offline:
                    leaveApplicationStackVw.isHidden = true
                    
                    if let _ = data.document {
                        actionBtn.isHidden = true
                    } else {
                        actionBtn.isHidden = false
                        actionBtn.backgroundColor = UIColor.cwBlue
                        actionBtn.setTitleColor(.white, for: .normal)
                        actionBtn.setTitle("Add document", for: .normal)
                    }
                    
                case .Approved, .Applied:
                    leaveApplicationStackVw.isHidden = false
                    
                    if let _ = data.document {
                        actionBtn.isHidden = true
                    } else {
                        actionBtn.isHidden = false
                        leaveTitleLbl.text = leave.title
                        actionBtn.backgroundColor = UIColor.white
                        actionBtn.setTitleColor(.cwBlue, for: .normal)
                        actionBtn.setTitle("Approve leave", for: .normal)
                        leaveDescriptionLbl.text = leave.userLeaveDescription
                    }
                }
            }
        }
    }
}

enum CleanerStatus: String {
    
    case Available = "Available"
    case Offline   = "Offline"
    case Approved  = "Leave approved"
    case Applied   = "Applied for leave"
    
    var color: UIColor {
        switch self {
        case .Available : return UIColor.availableGreen
        case .Offline   : return UIColor.offlineGrey
        case .Approved  : return UIColor.approvedOrange
        case .Applied   : return UIColor.appliedPurple
        }
    }
}
