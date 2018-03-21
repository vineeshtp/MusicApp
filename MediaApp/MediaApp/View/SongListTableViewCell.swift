//
//  SongListTableViewCell.swift
//  MediaApp
//
//  Created by Vineesh
//  Copyright © 2018 Media. All rights reserved.
//

import UIKit
import MediaPlayer

class SongListTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadSongs(param:MPMediaItem) {
        self.titleLabel.text = param.albumTitle
        self.artistLabel.text = param.artist
        self.imgView.image = param.artwork?.image(at: self.imgView.frame.size)
    }

}
