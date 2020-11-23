//
//  NGVideoPageViewController.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 17/11/20.
//

import UIKit

typealias VideoIndex = (url: String, index: Int)

class NGVideoPageViewController: UIPageViewController {

    // MARK: - Variables
    var videos = [Video]()
    var selectedIndex: Int = 0

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagination()
        setupInitialStream()
    }

    //MARK: Setup UIPageViewController
    fileprivate func setupPagination() {
        self.dataSource = self
        self.delegate = self
        let dismissStreamGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        dismissStreamGesture.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(dismissStreamGesture)
    }

    //MARK: Setup initial stream
    fileprivate func setupInitialStream() {
        let viewController = NGVideoPlayerViewController.initialize(urlString: videos[selectedIndex].url ?? "", andIndex: selectedIndex, isPlaying: true, videos: self.videos)
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }

    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: Instantiate current view controller
    static func initialize(with videos:[Video], index: Int) -> NGVideoPageViewController {
        let storyboard = UIStoryboard(name: Constants.Strings.StoryboardMain, bundle: nil)
        let videosPageViewController = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.NGVideoPageViewController) as! NGVideoPageViewController
        videosPageViewController.videos = videos
        videosPageViewController.selectedIndex = index
        return videosPageViewController
    }

    //MARK: Index and stream data handler.
    private func updateVideoIndex(fromIndex index: Int) {
        selectedIndex = index
    }

    private func getPreviousVideoIndex() -> VideoIndex? {
        return getVideoIndex(atIndex: selectedIndex - 1)
    }

    private func getNextVideoIndex() -> VideoIndex? {
        return getVideoIndex(atIndex: selectedIndex + 1)
    }

    private func getVideoIndex(atIndex index: Int) -> VideoIndex? {
        guard index >= 0 && index < videos.count else {
            return nil
        }
        return (url: videos[index].url ?? "", index: index)
    }

}

//MARK: PageViewController Delegates and Datasources.
extension NGVideoPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let videoIndex = getPreviousVideoIndex() else {
            return nil
        }

        return NGVideoPlayerViewController.initialize(urlString: videoIndex.url, andIndex: videoIndex.index, isPlaying: true, videos: self.videos)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let videoIndex = getNextVideoIndex() else {
            return nil
        }

        return NGVideoPlayerViewController.initialize(urlString: videoIndex.url, andIndex: videoIndex.index, isPlaying: true, videos: self.videos)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard completed else { return }

        if let viewController = pageViewController.viewControllers?.first as? NGVideoPlayerViewController,
            let previousViewController = previousViewControllers.first as? NGVideoPlayerViewController {
            previousViewController.pausePlayingVideo()
            viewController.startPlayingVideo()
            self.updateVideoIndex(fromIndex: viewController.index)
        }
    }
}


