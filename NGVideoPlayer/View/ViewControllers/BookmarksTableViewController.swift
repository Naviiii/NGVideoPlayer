//
//  BookmarksTableViewController.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 23/11/20.
//

import UIKit

class BookmarksTableViewController: UITableViewController {

    // MARK: - Variables
    var bookMarks = [Video]() {
        didSet{
            self.tableView.reloadData()
        }
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bookMarks = Video.getBookmarks() ?? []
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookMarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bookMarks[indexPath.row].title
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videosPageViewController = NGVideoPageViewController.initialize(with: bookMarks, index: indexPath.row)
        videosPageViewController.modalPresentationStyle = .fullScreen
        videosPageViewController.modalTransitionStyle = .coverVertical
        self.present(videosPageViewController, animated: true, completion: nil)
    }

}
