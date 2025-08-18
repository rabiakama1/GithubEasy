//
//  HomeTableViewCell.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var itemView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
    }
}
