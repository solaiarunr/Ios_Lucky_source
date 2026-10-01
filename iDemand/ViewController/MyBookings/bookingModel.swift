/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct bookingModel : Codable {
    let status_code : Int?
    let items : [bookingItems]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        items = try values.decodeIfPresent([bookingItems].self, forKey: .items)
    }

}

struct bookingItems : Codable {
	let item_image : String?
	let date : String?
	let item_id : String?
	let location : String?
	let price : String?
	let status : String?
    let item_name : String?
    let reference_id : String?

    

	enum CodingKeys: String, CodingKey {

		case item_image = "item_image"
		case date = "date"
		case item_id = "item_id"
		case location = "location"
		case price = "price"
		case status = "status"
        case item_name = "item_name"
        case reference_id = "reference_id"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		item_image = try values.decodeIfPresent(String.self, forKey: .item_image)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		status = try values.decodeIfPresent(String.self, forKey: .status)
        item_name = try values.decodeIfPresent(String.self, forKey: .item_name)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)

	}

}
