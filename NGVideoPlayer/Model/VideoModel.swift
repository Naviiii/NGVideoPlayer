//
//  VideoModel.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 16/11/20.
//

import Foundation
import UIKit
import Photos

class Video: Codable {
    var title: String?
    var url: String?
//    var thumbnailImage: Data?

    //    init(title: String, url: String, thumbnailImage: UIImage) {
    //        self.title = title
    //        self.url = url
    //        self.thumbnailImage = thumbnailImage
    //    }

    init(asset: PHAsset) {
        title = asset.value(forKey: "filename") as? String
        VideoUtility.getURL(ofPhotoWith: asset) { (url) in
            self.url = url?.absoluteString
//            if let videoUrl =  url {
//                DispatchQueue.main.async {
//                    self.thumbnailImage = VideoUtility.generateThumbnail(path: videoUrl)?.jpegData(compressionQuality: 1.0)
//
//                }
//
//            }
        }
    }

    public static func saveBookmarks(videoArray: [Video]){
        do {
            let videosData = try JSONEncoder().encode(videoArray)
            UserDefaults.standard.set(videosData, forKey: Constants.Strings.BookmarkKey)
        } catch let error {
            print(error)
        }
    }

    public static func getBookmarks() -> [Video]?{
        if let videosData = UserDefaults.standard.data(forKey: Constants.Strings.BookmarkKey) {
            do {
                let videosArray = try JSONDecoder().decode([Video].self, from: videosData)
                return videosArray
            } catch {
                print(error)
            }

            return nil
        }

        return nil
    }
}
