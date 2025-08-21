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
    
    private var currentPage = 1
    private var currentQuery = ""
    private var isLoading = false
    private var hasMoreUsers = true
    var onStateChange: ((ViewState<[UserItemModel]>) -> Void)?
    var onRowUpdate: ((IndexPath, UserItemModel) -> Void)?
    private var cellViewModels: [UserItemModel] = []
    
    init(searchUsersUseCase: SearchUsersUseCase, addFavoriteUseCase: AddFavoriteUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase, isFavoriteUseCase: IsFavoriteUseCase) {
        self.searchUsersUseCase = searchUsersUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        startObservingFavoriteChanges()
    }
    
    func start() {
        onStateChange?(.empty("Search a user..."))
    }
    
    func search(query: String) {
        currentQuery = query
        currentPage = 1
        cellViewModels = []
        hasMoreUsers = true
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            onStateChange?(.empty("Search a user..."))
            return
        }
        fetchUsers()
    }
    
    func loadMoreUsers() {
        guard !isLoading && hasMoreUsers else { return }
        currentPage += 1
        fetchUsers()
    }
    
    private func fetchUsers() {
        isLoading = true
        if currentPage == 1 {
            onStateChange?(.loading)
        }
        searchUsersUseCase.execute(query: currentQuery, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                if users.isEmpty {
                    self.hasMoreUsers = false
                }
                let newCellViewModels = self.mapUsersToCellViewModels(users)
                self.cellViewModels.append(contentsOf: newCellViewModels)
                
                if self.cellViewModels.isEmpty {
                    self.onStateChange?(.empty("Empty data"))
                } else {
                    self.onStateChange?(.success(self.cellViewModels))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.onStateChange?(.failure(error.localizedDescription))
            }
            
            self.isLoading = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startObservingFavoriteChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoriteStatusChange),
            name: .didUpdateFavoriteStatus,
            object: nil
        )
    }
    
    @objc private func handleFavoriteStatusChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let login = userInfo["login"] as? String else { return }
        
        if let index = cellViewModels.firstIndex(where: { $0.login == login }) {
            let isNowFavorite = isFavoriteUseCase.execute(login: login)
            cellViewModels[index].isFavorite = isNowFavorite
            let indexPath = IndexPath(row: index, section: 0)
            onRowUpdate?(indexPath, cellViewModels[index])
        }
    }
    
    func toggleFavoriteStatus(for indexPath: IndexPath) {
        guard indexPath.row < cellViewModels.count else { return }
        var viewModel = cellViewModels[indexPath.row]
        let userToToggle = User(login: viewModel.login, avatarUrl: viewModel.avatarUrl, profileUrl: viewModel.profileUrl)
        
        if viewModel.isFavorite {
            removeFavoriteUseCase.execute(login: userToToggle.login)
        } else {
            addFavoriteUseCase.execute(user: userToToggle)
        }
        
        viewModel.isFavorite.toggle()
        cellViewModels[indexPath.row] = viewModel
        //favori listesinde bir user silindiğinde ana listeyi tetiklemek için
        let userInfo = ["login": userToToggle.login]
        NotificationCenter.default.post(name: .didUpdateFavoriteStatus, object: nil, userInfo: userInfo)
        onRowUpdate?(indexPath, viewModel)
    }
    
    private func mapUsersToCellViewModels(_ users: [User]) -> [UserItemModel] {
        return users.map { user in
            let isFavorite = isFavoriteUseCase.execute(login: user.login)
            return UserItemModel(login: user.login, avatarUrl: user.avatarUrl, profileUrl: user.profileUrl, isFavorite: isFavorite)
        }
    }
}
