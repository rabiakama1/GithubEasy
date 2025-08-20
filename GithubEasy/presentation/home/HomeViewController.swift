//
//  HomeViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel: HomeViewModel
    private var users: [UserItemModel] = []
    
    var onUserSelected: ((String) -> Void)?
    
    private var searchWorkItem: DispatchWorkItem?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.start()
    }
    
    private func setupUI() {
        self.title = "Home"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let nib = UINib(nibName: HomeTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HomeTableViewCell.identifier)
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
        case .idle:
            removeLoading()
            users = []
            tableView.reloadData()
            tableView.removeBackgroundView()
        case .loading:
            showLoading()
        case .success(let userList):
            removeLoading()
            users = userList
            tableView.reloadData()
        case .failure(let error):
            removeLoading()
            showAlert(title: "Hata", message: error)
        case .empty(let message):
            removeLoading()
            users = []
            tableView.reloadData()
            tableView.setBackgroundView(message: message)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let userModel = users[indexPath.row]
        cell.configure(with: userModel)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUserLogin = users[indexPath.row].login
        onUserSelected?(selectedUserLogin)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 5 {
            viewModel.loadMoreUsers()
        }
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func didTapFavoriteButton(in cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleFavoriteStatus(at: indexPath.row)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.search(query: searchText)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newWorkItem)
        searchWorkItem = newWorkItem
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.search(query: "")
        searchBar.resignFirstResponder()
    }
}

extension UIViewController {
    func showLoading() { }
    func removeLoading() { }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension UITableView {
    func setBackgroundView(message: String) {  }
    func removeBackgroundView() {  }
}
