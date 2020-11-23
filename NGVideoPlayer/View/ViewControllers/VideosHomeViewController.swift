//
//  ViewController.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 14/11/20.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit

class VideosHomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var videoListTableView: UITableView!

    // MARK: - Variables
    var videos = [Video]()
    var viewModel:VideosHomeViewModel?

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel?.fetchAllVideos()
        // Do any additional setup after loading the view.
    }

    // MARK: - IBActions
    @IBAction func bookmarkButtonAction(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "BookmarksTableViewController") as? BookmarksTableViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Private Methods
    private func configureViewModel() {
        viewModel = VideosHomeViewModel()
        viewModel?.delegate = self
        self.videoListTableView.delegate = viewModel
        self.videoListTableView.dataSource = viewModel
    }
    
}

// MARK: - VideosHomeViewModelDelegate Methods
extension VideosHomeViewController: VideosHomeViewModelDelegate {
    func didFinishFetch() {
        self.videoListTableView.reloadData()
    }

    func presentVideoPlayer(videos: [Video], index: Int) {
        let videosPageViewController = NGVideoPageViewController.initialize(with: videos, index: index)
        videosPageViewController.modalPresentationStyle = .fullScreen
        videosPageViewController.modalTransitionStyle = .coverVertical
        self.present(videosPageViewController, animated: true, completion: nil)
    }
}


