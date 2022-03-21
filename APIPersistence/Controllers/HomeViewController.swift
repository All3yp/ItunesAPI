import UIKit

class AlbumInfo {
	let albumImage: String
	let albumName: String
	let artistName: String
	var trackNames: [String]

	init(
		albumImage: String,
		albumName: String,
		artistName: String,
		trackNames: [String]
	) {
		self.albumImage = albumImage
		self.albumName = albumName
		self.trackNames = trackNames
		self.artistName = artistName
	}
}

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!

	let api = GetMusicService()

	private var albums: [AlbumInfo] = [] {
		didSet {
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Albums"

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
			result?.results.forEach { element in
				if !(self?.albums.contains(where: { info in
					return info.albumName == element.collectionName
				}) ?? false) {
					let newAlbumInfo = AlbumInfo(albumImage: element.artworkUrl100, albumName: element.collectionName, artistName: element.artistName, trackNames: [element.trackName])
					self?.albums.append(newAlbumInfo)
				} else {
					let album = self?.albums.first { info in info.albumName == element.collectionName }!
					album?.trackNames.append(element.trackName)
				}
			}
		}

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumDetail" {
            if let albumDetailController = segue.destination as? AlbumDetailViewController,
                let sender = sender as? AlbumInfo {
                
                albumDetailController.receiveData(albumInfo: sender, isFavorite: false)
            }
        }
    }

}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAlbumDetail", sender: albums[indexPath.row])
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell()}
        
        let album = albums[indexPath.row]
        
		cell.configure(albumImage: album.albumImage, albumName: album.albumName, artistName: album.artistName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}
