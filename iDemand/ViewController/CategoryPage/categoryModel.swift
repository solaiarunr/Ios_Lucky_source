

import Foundation
//parent category model
struct categoryModel : Codable {
	let category : [Category]?
	let status_code : Int?
    let servicecategories : [Category]?

	enum CodingKeys: String, CodingKey {
        case servicecategories = "servicecategories"
		case category = "category"
		case status_code = "status_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		servicecategories = try values.decodeIfPresent([Category].self, forKey: .servicecategories)
		status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        category = try values.decodeIfPresent([Category].self, forKey: .category)

	}

}

struct Category : Codable {
    let parent_category_name : String?
    let parent_category_image : String?
    let parent_category_id : String?
    let parent_category_type : String?
    let parent_category_status : String?
    let location_type : String?
    
    enum CodingKeys: String, CodingKey {

        case parent_category_name = "parent_category_name"
        case parent_category_image = "parent_category_image"
        case parent_category_id = "parent_category_id"
        case parent_category_type = "parent_category_type"
        case parent_category_status = "parent_category_status"
        case location_type = "location_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        parent_category_name = try values.decodeIfPresent(String.self, forKey: .parent_category_name)
        parent_category_image = try values.decodeIfPresent(String.self, forKey: .parent_category_image)
        parent_category_id = try values.decodeIfPresent(String.self, forKey: .parent_category_id)
        parent_category_type = try values.decodeIfPresent(String.self, forKey: .parent_category_type)
        parent_category_status = try values.decodeIfPresent(String.self, forKey: .parent_category_status)
        location_type = try values.decodeIfPresent(String.self, forKey: .location_type)
    }

}

//sub category model
struct subcategoryModel : Codable {
    
    let subcategory : [Subcategory]?
    let status_code : Int?
    let how_it_works : String?
    let faq : String?
    let about_task : String?

    enum CodingKeys: String, CodingKey {

        case subcategory = "subcategory"
        case status_code = "status_code"
        case how_it_works = "how_it_works"
        case faq = "faq"
        case about_task = "about_task"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subcategory = try values.decodeIfPresent([Subcategory].self, forKey: .subcategory)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        how_it_works = try values.decodeIfPresent(String.self, forKey: .how_it_works)
        faq = try values.decodeIfPresent(String.self, forKey: .faq)
        about_task = try values.decodeIfPresent(String.self, forKey: .about_task)

    }

}
struct Subcategory : Codable {
    let sub_category_image : String?
    let sub_category_id : String?
    let sub_category_name : String?

    enum CodingKeys: String, CodingKey {

        case sub_category_image = "subcategory_image"
        case sub_category_id = "subcategory_id"
        case sub_category_name = "subcategory_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sub_category_image = try values.decodeIfPresent(String.self, forKey: .sub_category_image)
        sub_category_id = try values.decodeIfPresent(String.self, forKey: .sub_category_id)
        sub_category_name = try values.decodeIfPresent(String.self, forKey: .sub_category_name)
    }

}


// service model
struct ServicesModel : Codable {
    let status_code : Int?
    let services : [Services]?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case services = "services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        services = try values.decodeIfPresent([Services].self, forKey: .services)
    }

}
struct Services : Codable {
    let service_name : String?
    let service_id : String?
    let reviews : String?
    let rating : String?
    let service_image : String?
    let service_pricing : String?
    let service_price : String?
    let is_new : String?
    let service_status : String?

    enum CodingKeys: String, CodingKey {

        case service_name = "service_name"
        case service_id = "service_id"
        case reviews = "reviews"
        case rating = "rating"
        case service_image = "service_image"
        case service_pricing = "service_pricing"
        case service_price = "service_price"
        case is_new = "is_new"
        case service_status = "service_status"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        service_name = try values.decodeIfPresent(String.self, forKey: .service_name)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        reviews = try values.decodeIfPresent(String.self, forKey: .reviews)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        service_image = try values.decodeIfPresent(String.self, forKey: .service_image)
        service_pricing = try values.decodeIfPresent(String.self, forKey: .service_pricing)
        service_price = try values.decodeIfPresent(String.self, forKey: .service_price)
        is_new = try values.decodeIfPresent(String.self, forKey: .is_new)
        service_status = try values.decodeIfPresent(String.self, forKey: .service_status)

    }

}

