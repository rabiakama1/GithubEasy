//
//  Untitled.swift
//  GithubEasy
//
//  Created by rabiakama on 21.08.2025.
//

import UIKit

extension UITableView {
    
    func setBackgroundView(message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        label.text = message
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.sizeToFit()
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func removeBackgroundView() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
