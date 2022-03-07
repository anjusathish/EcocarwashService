//
//  LeaveModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 26/12/21.
//

import Foundation

// MARK: - LeaveModel
struct LeaveModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: [Leave]?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - Datum
struct Leave: Codable {
    let id: Int?
    let title, datumDescription, fromDate, toDate: String?
    let days: Int?
    let isApproved: Bool?
    let status, createdOn, updatedOn, user: String?
    let approvedBy: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case datumDescription = "description"
        case fromDate = "from_date"
        case toDate = "to_date"
        case days
        case isApproved = "is_approved"
        case status
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case user
        case approvedBy = "approved_by"
    }
}

struct ApplyLeaveModel: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let data: Leave?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
        case message = "Message"
    }
}
