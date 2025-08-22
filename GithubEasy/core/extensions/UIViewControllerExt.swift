//
//  UIViewControllerExt.swift
//  GithubEasy
//
//  Created by rabiakama on 22.08.2025.
//

import UIKit

fileprivate let loadingViewTag = 999

extension UIViewController {
    
    /*
        Frame'i, view'in değil, pencerenin boyutlarına göre ayarladım, loading esnasında tablar tıklanabilir olmasın diye
     */
    func showLoading() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        if window.viewWithTag(loadingViewTag) != nil {
            return
        }
        
        DispatchQueue.main.async {
            let overlayView = UIView()
            overlayView.frame = window.bounds
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView.tag = loadingViewTag
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = overlayView.center
            
            overlayView.addSubview(activityIndicator)
            window.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }
    }
    
    func removeLoading() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        DispatchQueue.main.async {
            guard let loadingView = window.viewWithTag(loadingViewTag) else {
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                loadingView.alpha = 0.0
            }, completion: { _ in
                loadingView.removeFromSuperview()
            })
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
