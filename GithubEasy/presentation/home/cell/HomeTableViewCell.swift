//
//  HomeTableViewCell.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: HomeTableViewCell)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var itemView: UIView!
    private var currentImageURL: URL?
    
    static let identifier = "HomeTableViewCell"
    weak var delegate: HomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        avatarImg.layer.cornerRadius = avatarImg.frame.height / 2
        avatarImg.clipsToBounds = true
        itemView.layer.cornerRadius = 8
    }
    
    func configure(with userModel: UserItemModel) {
        nameLbl.text = userModel.login
        updateFavoriteButton(isFavorite: userModel.isFavorite)
        if let url = URL(string: userModel.avatarUrl) {
            loadImage(from: url)
        } else {
            avatarImg.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    private func loadImage(from url: URL) {
        currentImageURL = url
        avatarImg.image = UIImage(systemName: "person.circle.fill")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    if self?.currentImageURL == url {
                        self?.avatarImg.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteBtn.setImage(image, for: .normal)
        favoriteBtn.tintColor = isFavorite ? .systemYellow : .gray
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        delegate?.didTapFavoriteButton(in: self)
    }
}
