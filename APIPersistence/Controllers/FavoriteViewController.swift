//
//  FavoriteViewController.swift
//  AlbumAppScreens
//
//  Created by Aloc FL00030 on 19/03/22.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
	let api = GetMusicService()
    
	private var favoriteAlbums : [ResultModel] = [] {
		didSet {
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Albums Favoritos"
     
        delegates()
        setupLayout()
        registerCell()
        createData()
    }
    
    private func delegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width * 0.40, height: 164)
        layout.minimumLineSpacing = 12
        
        collectionView.collectionViewLayout = layout
    }
    
    private func registerCell() {
        let nib = UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
    private func createData() {
		api.fetchAlbuns { [weak self] result in
			self?.favoriteAlbums = result?.results ?? []
		}

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumDetail" {
            if let albumDetailController = segue.destination as? AlbumDetailViewController,
                let sender = sender as? AlbumInfo {
                
                albumDetailController.receiveData(albumInfo: sender, isFavorite: true)
            }
        }
    }


}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAlbumDetail", sender: favoriteAlbums[indexPath.row])
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell()}
        
        let album = favoriteAlbums[indexPath.row]
        
        cell.configure(albumImage: album.artworkUrl100, albumName: album.collectionName, artistName: album.trackName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteAlbums.count
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
}

