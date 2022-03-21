//
//  AlbumCollectionViewCell.swift
//  AlbumAppScreens
//
//  Created by Aloc FL00030 on 19/03/22.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    static let identifier = "AlbumCollectionViewCell"
    
    func configure(albumImage: String, albumName: String, artistName: String) {
		albumImageView.loadImage(from: albumImage)
        albumNameLabel.text = albumName
        trackNameLabel.text = artistName
    }

}
