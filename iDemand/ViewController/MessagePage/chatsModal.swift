/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct chatsModal : Codable {
    let status_code : Int?
    let chats : [Chats]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case chats = "chats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        chats = try values.decodeIfPresent([Chats].self, forKey: .chats)
    }

}
struct Chats : Codable {
	let user_id : String?
	let name : String?
	let user_image : String?
	let block : String?
	let chat_id : String?
	let date : String?
	let status : Int?
	let unread_count : String?
	let message : String?
	let location : String?

	enum CodingKeys: String, CodingKey {

		case user_id = "user_id"
		case name = "name"
		case user_image = "user_image"
		case block = "block"
		case chat_id = "chat_id"
		case date = "date"
		case status = "status"
		case unread_count = "unread_count"
		case message = "message"
		case location = "location"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		block = try values.decodeIfPresent(String.self, forKey: .block)
		chat_id = try values.decodeIfPresent(String.self, forKey: .chat_id)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		unread_count = try values.decodeIfPresent(String.self, forKey: .unread_count)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		location = try values.decodeIfPresent(String.self, forKey: .location)
	}

}
