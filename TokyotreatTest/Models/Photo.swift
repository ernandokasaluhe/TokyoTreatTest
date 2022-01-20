//
//  Photo.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation

final class Photo: NSObject {
    var name: String
    var desc: String
    var altDesc: String
    var urlRegular: String
    
    init?(dictionary: [String: Any]) {
        if let user = dictionary["user"] as? [String: Any] {
            if let name = user["name"] as? String {
                self.name = name
            } else {
                self.name = ""
            }
        } else {
            self.name = ""
        }
        
        if let desc = dictionary["description"] as? String {
            self.desc = desc
        } else {
            self.desc = ""
        }
        
        if let altDesc = dictionary["alt_description"] as? String {
            self.altDesc = altDesc
        } else {
            self.altDesc = ""
        }
        
        if let urls = dictionary["urls"] as? [String: Any] {
            if let urlRegular = urls["regular"] as? String {
                self.urlRegular = urlRegular
            } else {
                self.urlRegular = ""
            }
        } else {
            self.urlRegular = ""
        }
    }
}
