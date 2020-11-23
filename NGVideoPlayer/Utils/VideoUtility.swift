//
//  VideoUtility.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 16/11/20.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class VideoUtility {
    static func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }

    static func getURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
        } else if mPhasset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}


struct Constants {

    struct CellIdentifiers {
        static let CategoryTableViewCellIdentifier = "CategoryTableViewCell"
        static let VideoCollectionViewCellIdentifier = "VideoCollectionViewCell"
    }

    struct StoryboardIDs {
        static let NGVideoPageViewController = "NGVideoPageViewController"
        static let NGVideoPlayerViewController = "NGVideoPlayerViewController"
    }

    struct Strings {
        static let StoryboardMain = "Main"
        static let BookmarkKey = "bookmarks"
    }

}
