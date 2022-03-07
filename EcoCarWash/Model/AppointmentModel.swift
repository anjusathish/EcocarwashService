//
//  AppointmentModel.swift
//  Eco carwash Service
//
//  Created by Indium Software on 06/01/22.
//

import Foundation

// MARK: - AppointmentModel
struct AppointmentModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: [AppointmentData]?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - Datum
struct AppointmentData: Codable {
    let id: Int?
    let date: String?
    let totalTime, linkedRac: Int?
    let appointmentNature, appointmentType, paymentType: String?
    let paymentStatus, amountPaid, appointmentStatus, status: String?
    let cleaner, customer: Customer?
    let appliedCoupon: AppliedCoupon?
    let store: Store?
    let userCar: UserCar?
    let services: [Service]?
    let appointmentImages: [AppointmentImage]?
    let appointmentRating: AppointmentRating?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case id, date, address
        case totalTime = "total_time"
        case appointmentNature = "appointment_nature"
        case appointmentType = "appointment_type"
        case linkedRac = "linked_rac"
        case paymentType = "payment_type"
        case paymentStatus = "payment_status"
        case amountPaid = "amount_paid"
        case appointmentStatus = "appointment_status"
        case status, cleaner, customer
        case appliedCoupon = "applied_coupon"
        case store
        case userCar = "user_car"
        case services
        case appointmentImages = "appointment_images"
        case appointmentRating = "appointment_rating"
    }
}

// MARK: - AppliedCoupon
struct AppliedCoupon: Codable {
    let id: Int?
    let code, appliedCouponDescription, discountType, discountAmount: String?

    enum CodingKeys: String, CodingKey {
        case id, code
        case appliedCouponDescription = "description"
        case discountType = "discount_type"
        case discountAmount = "discount_amount"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let name, username, email, profileImage: String?

    enum CodingKeys: String, CodingKey {
        case name, username, email
        case profileImage = "profile_image"
    }
}

// MARK: - Service
struct Service: Codable {
    let id: Int?
    let serviceType, serviceNature, title, price: String?
    let timetaken: Int?
    let status, createdOn, updatedOn: String?
    let carType: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case serviceType = "service_type"
        case serviceNature = "service_nature"
        case title, price, timetaken, status
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case carType = "car_type"
    }
}

// MARK: - Store
struct Store: Codable {
    let address: Address?
    let name: String?
    let image: String?
    let email, mobileNo, rating: String?

    enum CodingKeys: String, CodingKey {
        case address, name, image, email
        case mobileNo = "mobile_no"
        case rating
    }
}

// MARK: - Address
struct Address: Codable {
    let address: String?
    let latitude, longitude: Double?
}

// MARK: - UserCar
struct UserCar: Codable {
    let id: Int?
    let carName, user, status, createdOn: String?
    let carModel: String?
    let carTypeID: Int?
    let carType: String?
    let carMakeID: Int?
    let carMake: String?
    let carModelID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case carName = "car_name"
        case user, status
        case createdOn = "created_on"
        case carModel = "car_model"
        case carTypeID = "car_type_id"
        case carType = "car_type"
        case carMakeID = "car_make_id"
        case carMake = "car_make"
        case carModelID = "car_model_id"
    }
}

// MARK: - AppointmentImage
struct AppointmentImage: Codable {
    let id: Int?
    let imageType: String?
    let image: String?
    let appointment: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case imageType = "image_type"
        case image, appointment
    }
}

// MARK: - AppointmentRating
struct AppointmentRating: Codable {
    let rating: Int?
    let review: String?
}

// MARK: - AppointmentDetailModel
struct AppointmentDetailModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: AppointmentData?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - ServiceModel
struct ServiceModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: [ServiceData]?
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

// MARK: - Datum
struct ServiceData: Codable {
    let id: Int?
    let service: Service?
    let isEnabled: Bool?
    let createdOn, updatedOn: String?
    let store: Int?

    enum CodingKeys: String, CodingKey {
        case id, service
        case isEnabled = "is_enabled"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case store
    }
}

// MARK: - StoreTimingModel
struct StoreTimingModel: Codable {
    let version: String?
    let statusCode: Int?
    let data: TimeData?
    let status: Bool?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case data = "Data"
        case status = "Status"
        case message = "Message"
    }
}

// MARK: - DataClass
struct TimeData: Codable {
    let id: Int?
    let startTime, endTime, createdOn, updatedOn: String?
    let store: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case store
    }
}

// MARK: - UpdateAppointmentModel
struct UpdateAppointmentModel: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let data: UpdareAppointment?
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
struct UpdareAppointment: Codable {
    let id: Int?
    let totalTime: Int?
    let date, appointmentNature, appointmentType, paymentType, paymentStatus: String?
    let amountPaid, appointmentStatus, status, createdOn: String?
    let updatedOn, customer: String?
    let cleaner: Cleaner?
    let store, address, userCar, linkedRac: Int?
    let appliedCoupon: Int?
    let services: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, date
        case totalTime = "total_time"
        case appointmentNature = "appointment_nature"
        case appointmentType = "appointment_type"
        case paymentType = "payment_type"
        case paymentStatus = "payment_status"
        case amountPaid = "amount_paid"
        case appointmentStatus = "appointment_status"
        case status
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case customer, cleaner, store, address
        case userCar = "user_car"
        case linkedRac = "linked_rac"
        case appliedCoupon = "applied_coupon"
        case services
    }
}

// MARK: - AppointmentImageModel
struct AppointmentImageModel: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let data: AppointmentImage?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
        case status = "Status"
    }
}
