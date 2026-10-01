/*
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/
// MARK: - GetSubcategoryModel
struct GetSubcategoryModel : Codable {
    let subcategories : [Subcategories1]?
    let status_code : Int?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case subcategories = "subcategories"
        case status_code = "status_code"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subcategories = try values.decodeIfPresent([Subcategories1].self, forKey: .subcategories)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

struct Subcategories1 : Codable {
    let subcategory_name : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case subcategory_name = "subcategory_name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subcategory_name = try values.decodeIfPresent(String.self, forKey: .subcategory_name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

