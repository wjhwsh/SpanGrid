//
//  Photo.swift
//  GridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//  Copyright © 2017 WJH. All rights reserved.
//

import Foundation
struct Photo {
    let imageUrl: String
    let thumbnailUrl: String
    let id: String
    let title: String
    let owner: String

        /*
    s	small square 75x75
    q	large square 150x150
    t	thumbnail, 100 on longest side
    m	small, 240 on longest side
    n	small, 320 on longest side
    -	medium, 500 on longest side
    z	medium 640, 640 on longest side
    c	medium 800, 800 on longest side†
    b	large, 1024 on longest side*
    h	large 1600, 1600 on longest side†
    k	large 2048, 2048 on longest side†
    o	original image, either a jpg, gif or png, depending on source format
 */

    static func flickrPhotoUrl(withFarm farm: Int, server: String, secret: String, photoId: String, photoSizeLetter:String) -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(photoSizeLetter).jpg/"
    }
    
    init(withFlickrPhotoDictionary photoDic: [String: Any]) {
        //
        let farm = photoDic["farm"] as? Int ?? 1
        let server = photoDic["server"] as? String ?? ""
        let photoId = photoDic["id"] as? String ?? ""
        id = photoId
        owner = photoDic["owner"] as? String ?? ""
        title = photoDic["title"] as? String ?? ""
        let secret = photoDic["secret"] as? String ?? ""
        self.imageUrl = Photo.flickrPhotoUrl(withFarm: farm, server: server, secret: secret, photoId: photoId, photoSizeLetter: "c")
        self.thumbnailUrl = Photo.flickrPhotoUrl(withFarm: farm, server: server, secret: secret, photoId: photoId, photoSizeLetter: "t")
    }
}
