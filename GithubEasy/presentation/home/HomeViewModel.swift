//
//  HomeViewModel.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case failure(String)
    case empty(String)
}


final class HomeViewModel {
    private let searchUsersUseCase: SearchUsersUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    
    var onStateChange: ((ViewState<[UserItemModel]>) -> Void)?
    
    private var cellViewModels: [UserItemModel] = [] {
        didSet {
            onStateChange?(.success(cellViewModels))
        }
    }
    
    init(searchUsersUseCase: SearchUsersUseCase, addFavoriteUseCase: AddFavoriteUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase, isFavoriteUseCase: IsFavoriteUseCase) {
        self.searchUsersUseCase = searchUsersUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
    }
    
    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.cellViewModels = []
            onStateChange?(.idle)
            return
        }
        
        onStateChange?(.loading)
        
        searchUsersUseCase.execute(query: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                if users.isEmpty {
                    self.onStateChange?(.empty("Sonuç bulunamadı."))
                } else {
                    self.cellViewModels = self.mapUsersToCellViewModels(users)
                }
            case .failure(let error):
                self.onStateChange?(.failure(error.localizedDescription))
            }
        }
    }
    
    func toggleFavoriteStatus(at index: Int) {
        guard index < cellViewModels.count else { return }
        var viewModel = cellViewModels[index]
        let userToToggle = User(login: viewModel.login, avatarUrl: viewModel.avatarUrl, profileUrl: viewModel.profileUrl)
        if viewModel.isFavorite {
            removeFavoriteUseCase.execute(login: userToToggle.login)
        } else {
            addFavoriteUseCase.execute(user: userToToggle)
        }
        
        viewModel.isFavorite.toggle()
        cellViewModels[index] = viewModel
    }
    
    private func mapUsersToCellViewModels(_ users: [User]) -> [UserItemModel] {
        return users.map { user in
            let isFavorite = isFavoriteUseCase.execute(login: user.login)
            return UserItemModel(login: user.login, avatarUrl: user.avatarUrl, profileUrl: user.profileUrl, isFavorite: isFavorite)
        }
    }
}
