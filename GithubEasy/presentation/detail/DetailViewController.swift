//
//  DetailViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    private let viewModel: DetailViewModel
    
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
        self.title = userDetail.login
        userNameLbl.text = userDetail.login
        profileLbl.text = userDetail.htmlUrl
        
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
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteBtn.setImage(image, for: .normal)
        favoriteBtn.tintColor = isFavorite ? .systemYellow : .gray
    }
    
}
