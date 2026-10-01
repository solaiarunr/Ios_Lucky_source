/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BrowseModal : Codable {
    let status_code : Int?
    let items : [Jobs]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        items = try values.decodeIfPresent([Jobs].self, forKey: .items)
    }

}
struct Jobs : Codable {
	let description : String?
	let user_id : String?
	let parent_category_id : String?
	let service_image : String?
	let service_id : String?
	let date : String?
	let location : String?
	let subcategory_id : String?
	let user_name : String?
	let booking_price : String?
	let parent_category_name : String?
	let item_id : String?
	let user_image : String?
	let name : String?
	let subcategory_name : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case user_id = "user_id"
		case parent_category_id = "parent_category_id"
		case service_image = "service_image"
		case service_id = "service_id"
		case date = "date"
		case location = "location"
		case subcategory_id = "subcategory_id"
		case user_name = "user_name"
		case booking_price = "booking_price"
		case parent_category_name = "parent_category_name"
		case item_id = "item_id"
		case user_image = "user_image"
		case name = "name"
		case subcategory_name = "subcategory_name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		parent_category_id = try values.decodeIfPresent(String.self, forKey: .parent_category_id)
		service_image = try values.decodeIfPresent(String.self, forKey: .service_image)
		service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		subcategory_id = try values.decodeIfPresent(String.self, forKey: .subcategory_id)
		user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
		booking_price = try values.decodeIfPresent(String.self, forKey: .booking_price)
		parent_category_name = try values.decodeIfPresent(String.self, forKey: .parent_category_name)
		item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		subcategory_name = try values.decodeIfPresent(String.self, forKey: .subcategory_name)
	}

}
