//
//  PhotoModel.swift
//  SpanGridLayoutDemo
//
//  Created by Jianhua Wang on 2/18/17.
//
//

import Foundation
enum SearchType {
    case category
    case text
}

protocol PhotoDataSource {
    func loadingPhoto(more: Bool, completion:  @escaping (Error?) -> Void) -> Void
    var hasMorePhoto: Bool { get }
    var totalPhotoCount: Int { get }
    var photos: [Photo] { get }
}

class PhotoModel : PhotoDataSource {
    var photos = [Photo]()
    var hasMorePhoto: Bool = true
    var totalPhotoCount: Int = 0
    var searchType: SearchType = .category
    var offset = 0
    var limit = 20
    
    func loadingPhoto(more: Bool, completion: @escaping (Error?) -> Void) {
        //
        if(!more) {
            photos.removeAll()
            totalPhotoCount = 0
            hasMorePhoto = true
        }
        if(self.searchType == .category) {
            PhotoService.sharedInstance.serviceClient?.searchPhoto(withCategory: "", offset: offset, limit: limit, completion: { (response) in
                //
                if let photos = (response.result.value as? [String: Any])?["photos"] as? [String : Any] {
                    self.totalPhotoCount = photos["total"] as! Int
                    if let photoList = photos["photo"] as? [[String : Any]] {
                        let photoObjectList = photoList.flatMap{Photo(withFlickrPhotoDictionary: $0)}
                        self.photos += photoObjectList
                    }
                }
                completion(response.error)
            })
        }
        else {
            PhotoService.sharedInstance.serviceClient?.searchPhoto(withText: "", offset: offset, limit: limit, completion: { (response) in
                //
                completion(response.error)
            })
        }
    }
}
