//
//  MovieDetailTableViewCell.swift
//  MovieToYou
//
//  Created by Victor Vidal on 02/07/21.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviewLikes: UILabel!
    @IBOutlet weak var movieViews: UILabel!
    var didTapFavoriteButton: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favorite(_ sender: UIButton) {
        didTapFavoriteButton.toggle()
        if didTapFavoriteButton{
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}
