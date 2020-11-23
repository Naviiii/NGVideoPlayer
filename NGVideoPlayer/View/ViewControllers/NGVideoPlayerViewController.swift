//
//  NGVideoPlayerViewController.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 17/11/20.
//

import UIKit
import AVKit

class NGVideoPlayerViewController: AVPlayerViewController {

    // MARK: - Variables
    var index: Int = 0
    var streamURL: String = ""
    var isPlaying: Bool = false
    var videos: [Video]?
    var loader = UIActivityIndicatorView(style: .gray)
    var bookmarkButton = UIButton(type: .custom)

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseVideoURL()
        setupUI()
        observePlaybackState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        player?.pause()
    }

    // MARK: -  Private Methods
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func bookmarkVideo() {
        if let video = videos?[index] {
            if var bookmarkedItems = Video.getBookmarks() {

                if bookmarkedItems.filter({$0.url == video.url}).count > 0 {
                    bookmarkedItems =  bookmarkedItems.filter({$0.url != video.url})
                    bookmarkButton.setImage(UIImage(named: "ic_shortlist"), for: .normal)
//                    bookmarkButton.imageView?.image = bookmarkButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
                    bookmarkButton.imageView?.tintColor = .systemBlue
                } else {
                    bookmarkButton.setImage(UIImage(named: "ic_shortlisted"), for: .normal)
                    bookmarkButton.imageView?.tintColor = .systemRed
                    bookmarkedItems.append(video)
                }

                Video.saveBookmarks(videoArray: bookmarkedItems)
            } else {
                bookmarkButton.setImage(UIImage(named: "ic_shortlisted"), for: .normal)
                bookmarkButton.imageView?.tintColor = .systemRed
                let bookmarkedItems = [video]
                Video.saveBookmarks(videoArray: bookmarkedItems)
            }
        }
    }

    fileprivate func setupUI() {
        self.showsPlaybackControls = false
        self.contentOverlayView?.addSubview(loader)
        self.contentOverlayView?.center = self.view.center
        if let center = self.contentOverlayView?.center {
            loader.center = center
        }
        loader.color = .white
        loader.startAnimating()
        loader.hidesWhenStopped = true

        let backButton = UIButton(type: .custom)
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let topMargin =  window.safeAreaInsets.top
            let leftMargin =  window.safeAreaInsets.left
            backButton.frame = CGRect(x: leftMargin + 20, y: topMargin + 30, width: 30, height: 30)
        }
        else {
            backButton.frame = CGRect(x: 20, y: 30, width: 30, height: 30)
        }

        backButton.setImage(UIImage(named: "back_button.png"), for: .normal)
        backButton.imageView?.image = backButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        backButton.imageView?.tintColor = .systemBlue
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        self.contentOverlayView?.addSubview(backButton)

        addBookmarkButton()

    }

    private func addBookmarkButton() {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let topMargin =  window.safeAreaInsets.top
            let rightMargin =  window.layer.bounds.width - 50
            bookmarkButton.frame = CGRect(x: rightMargin, y: topMargin + 30, width: 40, height: 40)
        } else {
            bookmarkButton.frame = CGRect(x: 20, y: 30, width: 40, height: 40)
        }

        if (Video.getBookmarks()?.filter({$0.url == streamURL}).count ?? 0) > 0 {
            self.bookmarkButton.setImage(UIImage(named: "ic_shortlisted.png"), for: .normal)
            self.bookmarkButton.imageView?.tintColor = .systemRed
        } else {
            bookmarkButton.setImage(UIImage(named: "ic_shortlist.png"), for: .normal)
            bookmarkButton.imageView?.image = bookmarkButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            bookmarkButton.imageView?.tintColor = .systemBlue
        }
        bookmarkButton.addTarget(self, action: #selector(bookmarkVideo), for: .touchUpInside)
        self.contentOverlayView?.addSubview(bookmarkButton)
    }

    private func observePlaybackState() {
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { [weak self] time in
            if self?.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                if self?.player?.currentItem?.isPlaybackLikelyToKeepUp ?? false {
                    self?.loader.stopAnimating()
                }
            }
        })
    }

    //MARK: - Instantiate ViewController.
    static func initialize(urlString: String, andIndex index: Int, isPlaying: Bool = false, videos: [Video]) -> NGVideoPlayerViewController {
        let storyboard = UIStoryboard(name: Constants.Strings.StoryboardMain, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.NGVideoPlayerViewController) as! NGVideoPlayerViewController
        viewController.streamURL = urlString
        viewController.videos = videos
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }

    //MARK: - Playback Handlers
    func initialiseVideoURL() {
        guard let url = URL(string: streamURL) else { return }
        player = AVPlayer(url: url)
        isPlaying ? startPlayingVideo() : nil
    }

    func startPlayingVideo() {
        player?.play()
    }

    func pausePlayingVideo() {
        player?.pause()
    }

}
