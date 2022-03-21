import UIKit

class AlbumTrackTableViewCell: UITableViewCell {
    
    static let identifier = "AlbumTrackTableViewCell"
    @IBOutlet weak var trackNameLabel: UILabel!
    
    func configure(trackName: String) {
        trackNameLabel.text = trackName
    }
}
