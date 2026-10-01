
import Foundation
struct LoginModel : Codable {
	let rating : String?
	let type : String?
	let email : String?
	let user_id : String?
	let mobile : String?
	let status_code : Int?
	let name : String?
	let access_token : String?
    let message : String?
    let account_exists : String?
    let new_account : String?

	enum CodingKeys: String, CodingKey {
		case rating = "rating"
		case type = "type"
		case email = "email"
		case user_id = "user_id"
		case mobile = "mobile"
		case status_code = "status_code"
		case name = "name"
		case access_token = "access_token"
        case message = "message"
        case account_exists = "account_exists"
        case new_account = "new_account"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rating = try values.decodeIfPresent(String.self, forKey: .rating)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        account_exists = try values.decodeIfPresent(String.self, forKey: .account_exists)
        new_account = try values.decodeIfPresent(String.self, forKey: .new_account)
	}
}
