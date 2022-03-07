//
//  LoginResposne.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 08/11/21.
//

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let data: LoginInfo?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - DataClass
struct LoginInfo: Codable {
    let accessToken, refreshToken, uuid, name: String?
    let email, profileImage, mobileNo: String?
    let userType: Int?
    let dateJoined, lastLogin: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case uuid, name, email
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case userType = "user_type"
        case dateJoined = "date_joined"
        case lastLogin = "last_login"
    }
}
