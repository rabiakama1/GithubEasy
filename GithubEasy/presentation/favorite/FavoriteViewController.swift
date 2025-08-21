//
//  FavoriteViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteTableView: UITableView!
    
    private let viewModel: FavoriteViewModel
    private var users: [UserItemModel] = []
    
    var onUserSelected: ((String) -> Void)?

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FavoriteViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }

    private func setupUI() {
        self.title = "Favorites"
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.keyboardDismissMode = .onDrag
        let nib = UINib(nibName: HomeTableViewCell.identifier, bundle: nil)
        favoriteTableView.register(nib, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleStateChange(state)
            }
        }
    }
    
    private func handleStateChange(_ state: ViewState<[UserItemModel]>) {
        switch state {
        case .loading:
            favoriteTableView.removeBackgroundView()
            showLoading()
        case .success(let userList):
            removeLoading()
            self.users = userList
            favoriteTableView.reloadData()
            favoriteTableView.removeBackgroundView()
        case .empty(let message):
            removeLoading()
            self.users = []
            favoriteTableView.reloadData()
            favoriteTableView.setBackgroundView(message: message)
        case .failure(let error):
            removeLoading()
            showAlert(title: "Hata", message: error)
        case .idle:
            removeLoading()
            favoriteTableView.removeBackgroundView()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: users[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUserLogin = users[indexPath.row].login
        onUserSelected?(selectedUserLogin)
    }
}

extension FavoriteViewController: HomeTableViewCellDelegate {
    
    func didTapFavoriteButton(in cell: HomeTableViewCell) {
        guard let indexPath = favoriteTableView.indexPath(for: cell) else { return }
        let userToRemove = users[indexPath.row]
        viewModel.removeFavorite(user: userToRemove)
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterFavorites(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.filterFavorites(with: "")
        searchBar.resignFirstResponder()
    }
}
