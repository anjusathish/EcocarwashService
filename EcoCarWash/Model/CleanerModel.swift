//
//  CleanerModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 29/12/21.
//

import Foundation

// MARK: - CleanerModel
struct CleanerModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: CleanerData?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - DataClass
struct CleanerData: Codable {
    let count: Int?
    let next, previous: String?
    let results: [Cleaner]?
}

// MARK: - Result
struct Cleaner: Codable {
    let uuid, name, username, email: String?
    let profileImage: String?
    let mobileNo: String?
    let userType: Int?
    let rating: String?
    let document: Document?
    let userLeave: UserLeave?
    let bankDetails: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, username, email
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case userType = "user_type"
        case rating, document
        case userLeave = "user_leave"
        case bankDetails = "bank_details"
    }
}

struct Document: Codable {
    
}

// MARK: - CleanerModel
struct CreateCleanerModel: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case status = "Status"
    }
}
