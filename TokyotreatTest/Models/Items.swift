//
//  Items.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation

final class Items: NSObject {
    var total: Int
    var totalPages: Int
    var items = [Photo]()
    
    init?(dictionary: [String: Any]) {
        if let total = dictionary["total"] as? Int {
            self.total = total
        } else {
            self.total = 0
        }
        
        if let totalPages = dictionary["total_pages"] as? Int {
            self.totalPages = totalPages
        } else {
            self.totalPages = 0
        }
        
        if let items = dictionary["results"] as? [[String: Any]] {
            for item in items {
                self.items.append(Photo(dictionary: item)!)
            }
        }
    }
}

extension Items: ResponseDataConvertible {
    convenience init?(rawData: Any) {
        if let dictionary = rawData as? [String: Any] {
            self.init(dictionary: dictionary)
        } else {
            return nil
        }
    }
}

extension Items {
    enum ItemsResult {
        case success(Items)
        case failure(Error)
    }
}
