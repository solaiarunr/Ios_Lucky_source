/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct HireModel : Codable {
    let items : [Technicians]?
    let status_code : Int?

    enum CodingKeys: String, CodingKey {

        case items = "items"
        case status_code = "status_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([Technicians].self, forKey: .items)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }

}


struct Technicians : Codable {
	let user_image : String?
	let name : String?
	let user_id : String?
	let rating : String?
	let price : String?
	let completed_tasks : String?
	let reviews : String?

	enum CodingKeys: String, CodingKey {

		case user_image = "user_image"
		case name = "name"
		case user_id = "user_id"
		case rating = "rating"
		case price = "price"
		case completed_tasks = "completed_tasks"
		case reviews = "reviews"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		rating = try values.decodeIfPresent(String.self, forKey: .rating)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		completed_tasks = try values.decodeIfPresent(String.self, forKey: .completed_tasks)
		reviews = try values.decodeIfPresent(String.self, forKey: .reviews)
	}

}
