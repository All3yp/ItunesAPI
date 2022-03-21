//
//  AlbumDetailViewController.swift
//  AlbumAppScreens
//
//  Created by Aloc FL00030 on 19/03/22.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    private var albumInfo: AlbumInfo = .init(albumImage: "", albumName: "Vazio", artistName: "", trackNames: [])
    private var isFavorite = false
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumArtistLabel: UILabel!
    @IBOutlet weak var albumTrackListView: UITableView!
    @IBOutlet weak var albumFavIconView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detalhes do Album"
       
        delegates()
        registerCell()
        presentData()
    }
    
    private func delegates() {
        albumTrackListView.delegate = self
        albumTrackListView.dataSource = self
    }
    
    private func registerCell() {
        let nib = UINib(nibName: AlbumTrackTableViewCell.identifier, bundle: nil)
        albumTrackListView.register(nib, forCellReuseIdentifier: AlbumTrackTableViewCell.identifier)
    }
    
    func receiveData(albumInfo: AlbumInfo, isFavorite: Bool) {
        self.albumInfo = albumInfo
        self.isFavorite = isFavorite
		self.albumInfo.trackNames = Array(Set(albumInfo.trackNames))
    }
    
    private func presentData() {
		albumImage.loadImage(from: albumInfo.albumImage)
		albumNameLabel.text = albumInfo.albumName
		albumArtistLabel.text = albumInfo.artistName

        albumFavIconView.imageView?.image = (isFavorite) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    
    @IBAction func onFavoriteClicked(_ sender: Any) {
        favoriteAlbum()
    }
    
    func favoriteAlbum() {
        // CODE FROM DATABASE
        
        if isFavorite {
            // Unfavorite album
            
            isFavorite = false
        }
        else {
            // Favorite album
            
            isFavorite = true
        }
        
        // UI Update
        DispatchQueue.main.async {
            self.albumFavIconView.imageView?.image = (self.isFavorite) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albumInfo.trackNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTrackTableViewCell.identifier, for: indexPath) as? AlbumTrackTableViewCell else { return UITableViewCell() }
        
		cell.configure(trackName: albumInfo.trackNames[indexPath.row])
        
        return cell
    }
    
    
}
