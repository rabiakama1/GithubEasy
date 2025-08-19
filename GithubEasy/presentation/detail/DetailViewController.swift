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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func favoriteBtnClicked(_ sender: Any) {
    }
    
}
