//
//  MovieRankTableViewCell.swift
//  MovieRank
//
//  Created by 박연배 on 2021/11/02.
//

import UIKit

class MovieRankTableViewCell: UITableViewCell {

    static let identifier = "MovieRankTableViewCell"
    
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    @IBOutlet weak var rankBackgroundView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
