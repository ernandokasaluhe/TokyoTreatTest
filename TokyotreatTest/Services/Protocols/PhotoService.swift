//
//  PhotoService.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation

protocol PhotoService {
    func getItems(q: String, page: Int, completionHandler: @escaping(Items.ItemsResult) -> Void)
}
