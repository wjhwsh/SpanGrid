//
//  FlickerClient.swift
//  GridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//  Copyright © 2017 WJH. All rights reserved.
//

import Foundation
import Alamofire

class FlickerClient: ServiceClient {
    static let apiKey = ""
    static let secret = ""
    let host = "api.flickr.com"
    let path = "/services/rest/"
    
    func request(method: String, params:[String : Any], completion: @escaping (DataResponse<Any>) -> Void) -> Void {
        let url = "https://\(host)\(path)?method=\(method)"
        Alamofire.request(url, parameters: params).responseJSON (completionHandler: completion)
    }
    
    func searchPhoto(withText: String, offset: Int, limit: Int, completion:  @escaping (DataResponse<Any>) -> Void) -> Void {
    
    }
    func searchPhoto(withCategory: String, offset: Int, limit: Int, completion:  @escaping (DataResponse<Any>) -> Void) -> Void {
        self.request(method: "flickr.interestingness.getList", params: ["per_page" : "\(limit)", "page" : "\(offset)", "api_key" : FlickerClient.apiKey, "format" : "json", "nojsoncallback" : "1"], completion: completion)
    }
}
