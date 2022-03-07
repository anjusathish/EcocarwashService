//
//  ProfileModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: ProfileData?
    let message: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
        case message = "Message"
    }
}

// MARK: - DataClass
struct ProfileData: Codable {
    let uuid, name, username, email: String?
    let profileImage, mobileNo: String?
    let userType: Int?
    let userLeave: UserLeave?
    let bankDetails: BankDetails?

    enum CodingKeys: String, CodingKey {
        case uuid, name, username, email
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case userType = "user_type"
        case userLeave = "user_leave"
        case bankDetails = "bank_details"
    }
}

// MARK: - UserLeave
struct UserLeave: Codable {
    let id: Int?
    let title, userLeaveDescription, fromDate, toDate: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case userLeaveDescription = "description"
        case fromDate = "from_date"
        case toDate = "to_date"
        case status
    }
}

struct BankDetails: Codable {
    let id: Int?
    let accountHolderName, accountNumber, ifscCode, bankName: String?
    let mobileNumber, createdOn, updatedOn, user: String?

    enum CodingKeys: String, CodingKey {
        case id
        case accountHolderName = "account_holder_name"
        case accountNumber = "account_number"
        case ifscCode = "ifsc_code"
        case bankName = "bank_name"
        case mobileNumber = "mobile_number"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case user
    }
}

// MARK: - UserProfileResponse
struct UserProfileResponse: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let message: String?
    let data: Profile?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case data = "Data"
        case message = "Message"
    }
}

// MARK: - DataClass
struct Profile: Codable {
    let uuid, name, username, email: String?
    let profileImage: String?
    let mobileNo: String?
    let isMobileVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case uuid, name, username, email
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case isMobileVerified = "is_mobile_verified"
    }
}
