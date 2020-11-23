//
//  VideoListTableViewCell.swift
//  NGVideoPlayer
//
//  Created by Naveen Gowda on 14/11/20.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
