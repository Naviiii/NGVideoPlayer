//
//  VideosHomeViewModel.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 24/11/20.
//

import Foundation
import Photos
import MobileCoreServices
import AVFoundation
import AVKit

protocol VideosHomeViewModelDelegate: class {
    func didFinishFetch()
    func presentVideoPlayer(videos: [Video], index: Int)
}

class VideosHomeViewModel: NSObject {
    weak var delegate: VideosHomeViewModelDelegate?

    var videos = [Video]() {
        didSet {
            delegate?.didFinishFetch()
        }
    }

    func fetchAllVideos() {
        let fetchOptions = PHFetchOptions()
        let allVideo = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        allVideo.enumerateObjects { (asset, index, bool) in
            self.videos.append(Video(asset: asset))
        }
    }

}

// MARK: - UITableViewDataSource
extension VideosHomeViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as? VideoListTableViewCell {
            cell.videoTitle.text = videos[indexPath.row].title
            if let url = URL(string : videos[indexPath.row].url ?? "") {
                DispatchQueue.main.async {
                    cell.videoThumbnailImageView.image = VideoUtility.generateThumbnail(path: url)
                }
            }

            return cell
        }

        return UITableViewCell()
    }


}

// MARK: - UITableViewDelegate
extension VideosHomeViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.presentVideoPlayer(videos: videos, index: indexPath.row)
    }
}

