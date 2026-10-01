/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NotificationModal : Codable {
    let status_code : Int?
    let items : [Notify]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        items = try values.decodeIfPresent([Notify].self, forKey: .items)
    }

}

struct Notify : Codable {
	let user_id : String?
	let item_id : String?
	let user_image : String?
	let name : String?
	let date : String?
	let location : String?
	let description : String?
	let item_type : String?
    let reference_id : String?
    let booking_date : String?
    let service_names : [String]?

    
	enum CodingKeys: String, CodingKey {

		case user_id = "user_id"
		case item_id = "item_id"
		case user_image = "user_image"
		case name = "name"
		case date = "date"
		case location = "location"
		case description = "description"
		case item_type = "item_type"
        case reference_id = "reference_id"
        case booking_date = "booking_date"
        case service_names = "service_names"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		item_type = try values.decodeIfPresent(String.self, forKey: .item_type)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)
        booking_date = try values.decodeIfPresent(String.self, forKey: .booking_date)
        service_names = try values.decodeIfPresent([String].self, forKey: .service_names)

	}

}
