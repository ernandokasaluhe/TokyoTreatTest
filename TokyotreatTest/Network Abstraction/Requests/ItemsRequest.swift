//
//  ItemsRequest.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Alamofire
import Foundation
import UIKit

struct ItemsRequest {
    var q: String
    var page: Int
}

extension ItemsRequest: Request {
    var baseURL: URL {
        return URL(fileURLWithPath: kAPIURL)
    }
    
    var path: String {
        return "search/photos?page=\(page)&query=\(q)"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": "Client-ID nf0vTyy7nT6p5a5MNg4LDIky2J8BIcA9uKSeHhg3VzI"]
    }
    
    typealias ResponseType = SingleDataResponse<Items>
}
