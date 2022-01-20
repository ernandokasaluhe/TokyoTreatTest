//
//  PhotoViewViewModel.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation

struct PhotoViewViewModel {
    
    private var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var imageURL: String {
        return photo.urlRegular
    }
    
    var name: String {
        return photo.name
    }
    
    var desc: String {
        return photo.desc
    }
    
    var altDesc: String {
        return photo.altDesc
    }
}
