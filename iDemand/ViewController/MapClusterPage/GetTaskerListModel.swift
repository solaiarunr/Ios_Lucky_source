/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/
// qwerty
// MARK: - GetTaskerListModel
struct GetTaskerListModel: Codable {
    let statusCode: Int?
    let tasker: [Tasker]?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case tasker
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tasker = try values.decodeIfPresent([Tasker].self, forKey: .tasker)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

// MARK: - Tasker
//modified-AR
struct Tasker: Codable {
    let taskerID, taskerName: String?
    let taskerImage: String?
    var taskerLocation, lon, lat: String?
    let categoryName, subCategoryName: String?
    let subcategoryId, categoryId : String?

    enum CodingKeys: String, CodingKey {
        case taskerID = "tasker_id"
        //modified-AR
        case taskerName = "tasker_name"
        case taskerImage = "tasker_image"
        case taskerLocation = "location"
        case categoryName = "category_name"
        case subCategoryName = "subcategory_name"
        case subcategoryId = "subcategory_id"
        case categoryId = "category_id"
        
        case lon, lat
    }
}



//model for tasker login map page
//modified-AR
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
struct GetTaskListModel: Codable {
    let items: [Item]?
    let statusCode: Int?
    //modified-AR
    let message: String?

    enum CodingKeys: String, CodingKey {
        case items
        case statusCode = "status_code"
        //modified-AR
        case message = "message"
    }
}

// MARK: - Item
struct Item: Codable {
    let itemID, date, serviceImage, lon: String?
    let name: String?
    let userImage: String?
    let userID: String?
    let lat: String?
    let parentCategoryName: String?
    let parentCategoryID: String?
    let subcategoryName: String?
    let serviceID, itemDescription, serviceName: String?
    let parentCategoryImage: String?
    let subcategoryImage: String?
    let subcategoryID: String?
    let bookingPrice, location: String?
    let parentCategoryType: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case date
        case serviceImage = "service_image"
        case lon, name
        case userImage = "user_image"
        case userID = "user_id"
        case lat
        case parentCategoryName = "parent_category_name"
        case parentCategoryID = "parent_category_id"
        case subcategoryName = "subcategory_name"
        case serviceID = "service_id"
        case itemDescription = "description"
        case serviceName = "service_name"
        case parentCategoryImage = "parent_category_image"
        case subcategoryImage = "subcategory_image"
        case subcategoryID = "subcategory_id"
        case bookingPrice = "booking_price"
        case location
        case parentCategoryType = "parent_category_type"
    }
}





