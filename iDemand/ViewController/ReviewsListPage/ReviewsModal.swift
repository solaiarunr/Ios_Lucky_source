/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
struct ReviewsModal : Codable {
    let status_code : Int?
    let items : [reviews_items]?
    
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        items = try values.decodeIfPresent([reviews_items].self, forKey: .items)
    }
}

struct reviews_items : Codable {
    let date : String?
    let review_id : String?
    let description : String?
    let user_image : String?
    let rating : String?
    let user_id : String?
    let user_name : String?
    let location : String?
    let reference_id : String?
    let booking_date : String?
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case review_id = "review_id"
        case description = "description"
        case user_image = "user_image"
        case rating = "rating"
        case user_id = "user_id"
        case user_name = "name"
        case location = "location"
        case reference_id = "reference_id"
        case booking_date = "booking_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        review_id = try values.decodeIfPresent(String.self, forKey: .review_id)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)
        booking_date = try values.decodeIfPresent(String.self, forKey: .booking_date)
    }
    
}
