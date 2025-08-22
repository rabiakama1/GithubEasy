//
//  DetailViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userNameTitle: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    private let viewModel: DetailViewModel
    private var userDetail: UserDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchUserDetails()
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleStateChange(state)
            }
        }
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        viewModel.toggleFavoriteStatus()
    }
    
    
    private func handleStateChange(_ state: ViewState<UserDetail>) {
        switch state {
        case .loading:
            showLoading()
        case .success(let userDetail):
            removeLoading()
            updateUI(with: userDetail)
        case .failure(let error):
            removeLoading()
            showAlert(title: "Hata", message: error)
        case .idle, .empty:
            removeLoading()
        }
    }
    
    private func updateUI(with userDetail: UserDetail) {
        detailView.layer.cornerRadius = 8
        userNameLbl.text = userDetail.login
        userNameTitle.text = "User Name : "
        nameLbl.text = userDetail.name
        nameTitle.text = "Name : "
        locationLbl.text = userDetail.location
        locationTitle.text = "Location : "
        self.title = userDetail.login
        profileLbl.text = userDetail.htmlUrl
        profileLbl.textColor = .systemBlue
        profileLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileLbl.addGestureRecognizer(tap)
        
        if let url = URL(string: userDetail.avatarUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.avatarImg.image = UIImage(data: data)
                    }
                }
            }
        }
        
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
    }
    
    @objc func openProfile() {
        if let url = URL(string: userDetail?.htmlUrl ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteBtn.setImage(image, for: .normal)
        favoriteBtn.tintColor = isFavorite ? .systemYellow : .gray
    }
    
}
