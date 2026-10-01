//
//  locationViewModel.swift
//  iDemand
//
//  Created by MAC pro 2.9Ghz on 04/08/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class locationViewModel{
    public func loadLocationData(address: String, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (String) -> Void) {
        let obj = BaseAPI()
        let parameter: [String: Any] = ["address": address, "key": GOOGLE_API_KEY]
        obj.getDataCall(subURl: GOOGLE_URL, params: parameter, onSuccess: { (response) in
            print(response)
            success(response)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
}
