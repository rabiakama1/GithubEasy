//
//  FavoriteViewController.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import UIKit

class FavoriteViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}
