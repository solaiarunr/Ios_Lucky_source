/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SearchModel : Codable {
	let items : [search_items]?
	let status_code : Int?

	enum CodingKeys: String, CodingKey {
		case items = "items"
		case status_code = "status_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		items = try values.decodeIfPresent([search_items].self, forKey: .items)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
	}

}

struct search_items : Codable {
    let type : String?
    let parent_category_image : String?
    let parent_category_name : String?
    let parent_category_id : String?
    let parent_category_type : String?
    let location_type : String?
    let subcategory_id : String?
    let service_image : String?
    let subcategory_image : String?
    let service_name : String?
    let subcategory_name : String?
    let service_id : String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case parent_category_image = "parent_category_image"
        case parent_category_name = "parent_category_name"
        case parent_category_id = "parent_category_id"
        case subcategory_id = "subcategory_id"
        case service_image = "service_image"
        case subcategory_image = "subcategory_image"
        case service_name = "service_name"
        case subcategory_name = "subcategory_name"
        case service_id = "service_id"
        case parent_category_type = "parent_category_type"
        case location_type = "location_type"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        parent_category_image = try values.decodeIfPresent(String.self, forKey: .parent_category_image)
        parent_category_name = try values.decodeIfPresent(String.self, forKey: .parent_category_name)
        parent_category_id = try values.decodeIfPresent(String.self, forKey: .parent_category_id)
        subcategory_id = try values.decodeIfPresent(String.self, forKey: .subcategory_id)
        service_image = try values.decodeIfPresent(String.self, forKey: .service_image)
        subcategory_image = try values.decodeIfPresent(String.self, forKey: .subcategory_image)
        service_name = try values.decodeIfPresent(String.self, forKey: .service_name)
        subcategory_name = try values.decodeIfPresent(String.self, forKey: .subcategory_name)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        parent_category_type = try values.decodeIfPresent(String.self, forKey: .parent_category_type)
        location_type = try values.decodeIfPresent(String.self, forKey: .location_type)

    }

}
