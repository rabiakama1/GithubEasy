//
//  HomeViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate,HomeTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var viewModel: HomeViewModel!
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        self.title = "Ara"
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        let nib = UINib(nibName: HomeTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    func didTapFavoriteButton(in cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleFavoriteStatus(at: indexPath.row)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
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
        
        return cell
    }
    
}

