

import Foundation
import SwiftyJSON

struct ProfileModel : Codable {
	let user_image : String?
	let user_id : String?
	let email : String?
	let name : String?
	let status_code : Int?
	let mobile : String?
	let rating : String?
    let location : String?
    let lat : String?
    let lon : String?
    let about : String?
//    let profile_verified : String?
    let stripe_public_key : String?
    let stripe_private_key : String?
    let chat_notification : String?
    let booking_notification : String?
    let payment_email : String?
    let booking_email : String?
    let work_mode : String?
    let password_less_login : String?
    let new_account : String?
    let payment_verified : String?

    
	enum CodingKeys: String, CodingKey {
		case user_image = "user_image"
		case user_id = "user_id"
		case email = "email"
		case name = "name"
		case status_code = "status_code"
		case mobile = "mobile"
		case rating = "rating"
        case location = "location"
        case about = "about"
//        case profile_verified = "profile_verified"
        case stripe_public_key = "stripe_public_key"
        case stripe_private_key = "stripe_private_key"
        case chat_notification = "chat_notification"
        case booking_notification = "booking_notification"
        case payment_email = "payment_email"
        case booking_email = "booking_email"
        case work_mode = "work_mode"
        case password_less_login = "password_less_login"
        case new_account = "new_account"
        case lat = "lat"
        case lon = "lon"
        case payment_verified = "payment_verified"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
		rating = try values.decodeIfPresent(String.self, forKey: .rating)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        about = try values.decodeIfPresent(String.self, forKey: .about)
//        profile_verified = try values.decodeIfPresent(String.self, forKey: .profile_verified)
        stripe_public_key = try values.decodeIfPresent(String.self, forKey: .stripe_public_key)
        stripe_private_key = try values.decodeIfPresent(String.self, forKey: .stripe_private_key)
        chat_notification = try values.decodeIfPresent(String.self, forKey: .chat_notification)
        booking_notification = try values.decodeIfPresent(String.self, forKey: .booking_notification)
        payment_email = try values.decodeIfPresent(String.self, forKey: .payment_email)
        booking_email = try values.decodeIfPresent(String.self, forKey: .booking_email)
        work_mode = try values.decodeIfPresent(String.self, forKey: .work_mode)
        password_less_login = try values.decodeIfPresent(String.self, forKey: .password_less_login)
        new_account = try values.decodeIfPresent(String.self, forKey: .new_account)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        payment_verified = try values.decodeIfPresent(String.self, forKey: .payment_verified)
	}

}
class StripeDataModel{
    var status: Int!
    var customer: String!
    var ephemeralKey: String!
    var paymentIntent: String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status_code"].intValue
        customer = json["customer_id"].stringValue
        ephemeralKey = json["ephemeralkey_id"].stringValue
        paymentIntent = json["paymentIntent_id"].stringValue
    }
    init(status: Int = 200,customer: String = "", ephemeralKey: String = "", paymentIntent: String = "") {
        self.status = status
        self.customer = customer
        self.ephemeralKey = ephemeralKey
        self.paymentIntent = paymentIntent
    }
}
