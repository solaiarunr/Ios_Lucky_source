// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getSubcategoryModel = try? newJSONDecoder().decode(GetSubcategoryModel.self, from: jsonData)

import Foundation

// MARK: - GetSubcategoryModel
struct GetSubcategoryModel: Codable {
    let status: String
    let statusCode: Int
    let subcategories: [Subcategory1]

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case subcategories
    }
}

// MARK: - Subcategory
struct Subcategory1: Codable {
    let id, subcategoryName: String

    enum CodingKeys: String, CodingKey {
        case id
        case subcategoryName = "subcategory_name"
    }
}


// MARK: - GetTaskDetatilModel
struct GetTaskDetatilModel: Codable {
    let items: [Needs]
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case items
        case statusCode = "status_code"
    }
}
// MARK: - Item
//struct Item1: Codable {
//    let sourceLat, parentCategoryID: String
//    let parentCategoryImage: String
//    let itemDescription, subcategoryID, sourceLocation, referenceID: String
//    let locationType: String
//    let subcategoryImage: String
//    let serviceImage, bookingPrice, name, itemID: String
//    let subcategoryName, dueStatus, serviceName, sourceLon: String
//    let activeStatus, parentCategoryName, userID, serviceID: String
//    let date: String
//
//    enum CodingKeys: String, CodingKey {
//        case sourceLat = "source_lat"
//        case parentCategoryID = "parent_category_id"
//        case parentCategoryImage = "parent_category_image"
//        case itemDescription = "description"
//        case subcategoryID = "subcategory_id"
//        case sourceLocation = "source_location"
//        case referenceID = "reference_id"
//        case locationType = "location_type"
//        case subcategoryImage = "subcategory_image"
//        case serviceImage = "service_image"
//        case bookingPrice = "booking_price"
//        case name
//        case itemID = "item_id"
//        case subcategoryName = "subcategory_name"
//        case dueStatus = "due_status"
//        case serviceName = "service_name"
//        case sourceLon = "source_lon"
//        case activeStatus = "active_status"
//        case parentCategoryName = "parent_category_name"
//        case userID = "user_id"
//        case serviceID = "service_id"
//        case date
//    }
//}
//
