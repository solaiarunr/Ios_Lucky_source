
import Foundation
struct HomeModel: Codable {
    let recent_items : [home_items]?
    let status_code : Int?
    let feature_items : [home_items]?
    let category_items : [home_items]?
    let banner_items : [home_items]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case recent_items = "recent_items"
        case status_code = "status_code"
        case feature_items = "feature_items"
        case category_items = "category_items"
        case banner_items = "banner_items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recent_items = try values.decodeIfPresent([home_items].self, forKey: .recent_items)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        feature_items = try values.decodeIfPresent([home_items].self, forKey: .feature_items)
        category_items = try values.decodeIfPresent([home_items].self, forKey: .category_items)
        banner_items = try values.decodeIfPresent([home_items].self, forKey: .banner_items)
    }
    
}

struct home_items : Codable {
    let item_id : String?
    let item_link : String?
    let item_image : String?
    let item_name : String?
    let description : String?
    let user_image : String?
    let user_name : String?
    let user_id : String?
    let price : String?
    let items : [home_items]?
    
    
    enum CodingKeys: String, CodingKey {
        case item_id = "item_id"
        case item_link = "item_link"
        case item_image = "item_image"
        case item_name = "item_name"
        case description = "description"
        case user_image = "user_image"
        case user_name = "user_name"
        case user_id = "user_id"
        case price = "price"
        case items = "items"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        item_id = try values.decodeIfPresent(String.self, forKey: .item_id)
        item_link = try values.decodeIfPresent(String.self, forKey: .item_link)
        item_image = try values.decodeIfPresent(String.self, forKey: .item_image)
        item_name = try values.decodeIfPresent(String.self, forKey: .item_name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        items = try values.decodeIfPresent([home_items].self, forKey: .items)
        
    }
    
}

struct homeData
{
    var type: String = ""
    var items : [home_items]?
    var item_name: String = ""
    var item_id: String = ""
    
    init(element: [String: Any]) {
        type = element["type"] as? String ?? ""
        item_name = element["item_name"] as? String ?? ""
        item_id = element["item_id"] as? String ?? ""
        items = element["items"] as? [home_items]
    }
    
    init(type:String,items:[home_items],item_name:String?,item_id:String?) {
        self.type = type
        self.items = items
        self.item_name = item_name!
        self.item_id = item_id!
    }
}




