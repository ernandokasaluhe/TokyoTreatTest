//
//  PhotoStore.swift
//  TokyotreatTest
//
//  Created by Ernando Kasaluhe on 19/01/22.
//

import Foundation

public class PhotoStore: PhotoService {
    public static let shared = PhotoStore()
    private init() {}
    
    func getItems(q: String, page: Int, completionHandler: @escaping (Items.ItemsResult) -> Void) {
        ItemsRequest(q: q, page: page).send() { result in
            switch result {
                
            case .success(let response):
                if let result = response.resultData {
                    completionHandler(.success(result))
                } else {
                    completionHandler(.failure(RequestError.invalidReturnedJSON))
                }
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }
    }
}
