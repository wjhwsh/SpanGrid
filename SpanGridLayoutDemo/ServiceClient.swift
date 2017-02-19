//
//  ServiceClient.swift
//  GridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//  Copyright © 2017 WJH. All rights reserved.
//

import Foundation
import Alamofire
protocol ServiceClient {

    func searchPhoto(withText: String, offset: Int, limit: Int, completion: @escaping (DataResponse<Any>) -> Void) -> Void
    func searchPhoto(withCategory: String, offset: Int, limit: Int, completion: @escaping (DataResponse<Any>) -> Void) -> Void
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let percentEscapedValue = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}
