//
//  PhotoService.swift
//  GridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//  Copyright © 2017 WJH. All rights reserved.
//

import Foundation

class PhotoService {
    static let sharedInstance : PhotoService = PhotoService()
    var serviceClient: ServiceClient?
    init() {
        serviceClient = nil
    }
}

