//
//  DetailViewModel.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

final class DetailViewModel {
    
    private let login: String
    private let getUserDetailUseCase: GetUserDetailsUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    
    var onStateChange: ((ViewState<UserDetail>) -> Void)?
    
    private(set) var isFavorite: Bool = false
    private var userDetail: UserDetail?

    init(login: String,
         getUserDetailUseCase: GetUserDetailsUseCase,
         addFavoriteUseCase: AddFavoriteUseCase,
         removeFavoriteUseCase: RemoveFavoriteUseCase,
         isFavoriteUseCase: IsFavoriteUseCase) {
        self.login = login
        self.getUserDetailUseCase = getUserDetailUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
    }
    
    
    func fetchUserDetails() {
        onStateChange?(.loading)
        
        self.isFavorite = isFavoriteUseCase.execute(login: self.login)
        
        getUserDetailUseCase.execute(username: self.login) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userDetail):
                self.userDetail = userDetail
                self.onStateChange?(.success(userDetail))
            case .failure(let error):
                self.onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
    
    func toggleFavoriteStatus() {
        guard let userDetail = self.userDetail else { return }
        
        let userToToggle = User(login: userDetail.login, avatarUrl: userDetail.avatarUrl, profileUrl: userDetail.htmlUrl)
        
        if isFavorite {
            removeFavoriteUseCase.execute(login: userToToggle.login)
        } else {
            addFavoriteUseCase.execute(user: userToToggle)
        }
        
        self.isFavorite.toggle()
        
        let userInfo = ["login": self.login]
        NotificationCenter.default.post(name: .didUpdateFavoriteStatus, object: nil, userInfo: userInfo)
        onStateChange?(.success(userDetail))
    }
}
