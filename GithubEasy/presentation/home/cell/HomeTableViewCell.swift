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
    private var currentTask: URLSessionDataTask?
    private let imageCache = NSCache<NSString, UIImage>()
    
    static let identifier = "HomeTableViewCell"
    weak var delegate: HomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        avatarImg.clipsToBounds = true
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImg.widthAnchor.constraint(equalToConstant: 50),
            avatarImg.heightAnchor.constraint(equalToConstant: 50)
        ])
        itemView.layer.cornerRadius = 8
        nameLbl.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLbl.setContentHuggingPriority(.required, for: .vertical)
        avatarImg.image = UIImage(systemName: "person.circle.fill")
        avatarImg.tintColor = .systemGray3
        avatarImg.contentMode = .scaleAspectFill
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentTask?.cancel()
        currentTask = nil
        currentImageURL = nil
        nameLbl.text = nil
        avatarImg.image = UIImage(systemName: "person.circle.fill")
        avatarImg.tintColor = .systemGray3
        delegate = nil
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImg.layer.cornerRadius = avatarImg.frame.height / 2
    }
    
    func configure(with userModel: UserItemModel) {
        nameLbl.text = userModel.login
        updateFavoriteButton(isFavorite: userModel.isFavorite)
        
        if let url = URL(string: userModel.avatarUrl) {
            loadImage(from: url)
        } else {
            avatarImg.image = UIImage(systemName: "person.circle.fill")
            avatarImg.tintColor = .systemGray3
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func loadImage(from url: URL) {
        currentTask?.cancel()
        currentImageURL = url
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.avatarImg.image = cachedImage
            self.avatarImg.tintColor = nil
            return
        }
        
        avatarImg.image = UIImage(systemName: "person.circle.fill")
        avatarImg.tintColor = .systemGray3
        
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data),
                  self.currentImageURL == url else {
                return
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                guard self.currentImageURL == url else { return }
                
                UIView.transition(with: self.avatarImg,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.avatarImg.image = image
                    self.avatarImg.tintColor = nil
                },
                                  completion: nil)
            }
        }
        
        currentTask?.resume()
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
