/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NeedModal : Codable {
    let status_code : Int?
    let items : [Needs]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        items = try values.decodeIfPresent([Needs].self, forKey: .items)
    }

}
struct Needs : Codable {
    let name : String?
    let user_id : String?
    let item_id : String?
    let subcategory_id : String?
    let date : String?
    let reference_id : String?
    let subcategory_name : String?
    let booking_price : String?
    let due_status : String?
    let service_name : String?
    let service_id : String?
    let service_image : String?
    let parent_category_image : String?
    let parent_category_name : String?
    let active_status : String?
    let description : String?
    let parent_category_id : String?
    let location_type : String?
    let dest_lat : String?
    let dest_location : String?
    let source_location : String?
    let source_lat : String?
    let dest_lon : String?
    let source_lon : String?
    // qwerty
    let subcategory_image : String?


    enum CodingKeys: String, CodingKey {
        case name = "name"
        case user_id = "user_id"
        case item_id = "item_id"
        case subcategory_id = "subcategory_id"
        case date = "date"
        case reference_id = "reference_id"
        case subcategory_name = "subcategory_name"
        case booking_price = "booking_price"
        case due_status = "due_status"
        case service_name = "service_name"
        case service_id = "service_id"
        case service_image = "service_image"
        case parent_category_image = "parent_category_image"
        case parent_category_name = "parent_category_name"
        case active_status = "active_status"
        case description = "description"
        case parent_category_id = "parent_category_id"
        case location_type = "location_type"
        case dest_lat = "dest_lat"
        case dest_location = "dest_location"
        case source_location = "source_location"
        case source_lat = "source_lat"
        case dest_lon = "dest_lon"
        case source_lon = "source_lon"
        // qwerty
        case subcategory_image = "subcategory_image"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
        subcategory_id = try values.decodeIfPresent(String.self, forKey: .subcategory_id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)
        subcategory_name = try values.decodeIfPresent(String.self, forKey: .subcategory_name)
        booking_price = try values.decodeIfPresent(String.self, forKey: .booking_price)
        due_status = try values.decodeIfPresent(String.self, forKey: .due_status)
        service_name = try values.decodeIfPresent(String.self, forKey: .service_name)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        service_image = try values.decodeIfPresent(String.self, forKey: .service_image)
        parent_category_image = try values.decodeIfPresent(String.self, forKey: .parent_category_image)
        parent_category_name = try values.decodeIfPresent(String.self, forKey: .parent_category_name)
        active_status = try values.decodeIfPresent(String.self, forKey: .active_status)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        parent_category_id = try values.decodeIfPresent(String.self, forKey: .parent_category_id)
        location_type = try values.decodeIfPresent(String.self, forKey: .location_type)
        dest_lat = try values.decodeIfPresent(String.self, forKey: .dest_lat)
        dest_location = try values.decodeIfPresent(String.self, forKey: .dest_location)
        source_location = try values.decodeIfPresent(String.self, forKey: .source_location)
        source_lat = try values.decodeIfPresent(String.self, forKey: .source_lat)
        dest_lon = try values.decodeIfPresent(String.self, forKey: .dest_lon)
        source_lon = try values.decodeIfPresent(String.self, forKey: .source_lon)
        // qwerty
        subcategory_image = try values.decodeIfPresent(String.self, forKey: .subcategory_image)

    }

}
