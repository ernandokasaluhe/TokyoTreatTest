//
//  SingleDataResponse.swift
//  WEPLus
//
//  Created by Ernando Kasaluhe on 07/11/18.
//  Copyright © 2018 Ernando Dev's. All rights reserved.
//

protocol ResponseDataConvertible {
    init?(rawData: Any)
}

struct SingleDataResponse<T: ResponseDataConvertible>: Response {
    let resultData: T?
    
    init?(json: Any) {
        self.resultData = T(rawData: json)
    }
    
}
