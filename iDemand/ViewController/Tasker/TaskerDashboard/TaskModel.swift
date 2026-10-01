/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct TaskModel : Codable {
	let total_pending : String?
	let earn : Earn?
	let upcoming : [Upcoming]?
	let upcoming_task : String?
	let total_earnings : String?
	let total_task : String?
	let status_code : Int?
	let total_completed : String?

	enum CodingKeys: String, CodingKey {

		case total_pending = "pending_earnings"
		case earn = "earn"
		case upcoming = "upcoming"
		case upcoming_task = "upcoming_tasks"
		case total_earnings = "total_earnings"
		case total_task = "total_tasks"
		case status_code = "status_code"
		case total_completed = "completed_tasks"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total_pending = try values.decodeIfPresent(String.self, forKey: .total_pending)
		earn = try values.decodeIfPresent(Earn.self, forKey: .earn)
		upcoming = try values.decodeIfPresent([Upcoming].self, forKey: .upcoming)
		upcoming_task = try values.decodeIfPresent(String.self, forKey: .upcoming_task)
		total_earnings = try values.decodeIfPresent(String.self, forKey: .total_earnings)
		total_task = try values.decodeIfPresent(String.self, forKey: .total_task)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
		total_completed = try values.decodeIfPresent(String.self, forKey: .total_completed)
	}

}



struct Earn : Codable {
    let year : [chart_data]?
    let month : [chart_data]?
    let week : [chart_data]?

    enum CodingKeys: String, CodingKey {

        case year = "year"
        case month = "month"
        case week = "week"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        year = try values.decodeIfPresent([chart_data].self, forKey: .year)
        month = try values.decodeIfPresent([chart_data].self, forKey: .month)
        week = try values.decodeIfPresent([chart_data].self, forKey: .week)
    }

}


struct Upcoming : Codable {
    let currency_symbol : String?
    let category_name : String?
    let status : String?
    let item_id : String?
    let category_id : String?
    let images : [String]?
    let price : String?
    let item_image : String?
    let item_name : String?
    let subcategory_name : String?
    let child_category_name : String?
    let child_category : String?
    let currency_code : String?
    let subcategory_id : String?
    let time : String?
    let description : String?
    let location : String?

    enum CodingKeys: String, CodingKey {

        case currency_symbol = "currency_symbol"
        case category_name = "category_name"
        case status = "status"
        case item_id = "item_id"
        case category_id = "parent_category_id"
        case images = "images"
        case price = "price"
        case item_image = "item_image"
        case item_name = "item_name"
        case subcategory_name = "subcategory_name"
        case child_category_name = "child_category_name"
        case child_category = "child_category"
        case currency_code = "currency_code"
        case subcategory_id = "subcategory_id"
        case time = "time"
        case description = "description"
        case location = "location"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        item_image = try values.decodeIfPresent(String.self, forKey: .item_image)
        item_name = try values.decodeIfPresent(String.self, forKey: .item_name)
        subcategory_name = try values.decodeIfPresent(String.self, forKey: .subcategory_name)
        child_category_name = try values.decodeIfPresent(String.self, forKey: .child_category_name)
        child_category = try values.decodeIfPresent(String.self, forKey: .child_category)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        subcategory_id = try values.decodeIfPresent(String.self, forKey: .subcategory_id)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        location = try values.decodeIfPresent(String.self, forKey: .location)
    }

}

struct chart_data : Codable {
    let earns : String?
    let duration : String?

    enum CodingKeys: String, CodingKey {

        case earns = "earns"
        case duration = "duration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        earns = try values.decodeIfPresent(String.self, forKey: .earns)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
    }

}

