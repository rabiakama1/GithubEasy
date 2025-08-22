//
//  MockUserRepository.swift
//  GithubEasy
//
//  Created by rabiakama on 22.08.2025.
//

import Foundation
@testable import GithubEasy

enum TestError: Error {
    case generic
}

final class MockUserRepository: UserRepositoryProtocol {
    
    var searchUsersCalled = false
    var getUserDetailCalled = false
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var getFavoritesCalled = false
    var isUserFavoriteCalled = false
    
    
    var searchUsersResult: Result<[User], Error>!
    var favorites: [User] = []
    
    
    func searchUsers(query: String, page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        searchUsersCalled = true
        completion(searchUsersResult)
    }
    
    func getUserDetail(login : String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
        getUserDetailCalled = true
    }
    
    func addFavorite(user: User) {
        addFavoriteCalled = true
        if !favorites.contains(where: { $0.login == user.login }) {
            favorites.append(user)
        }
    }
    
    func removeFavorite(login: String) {
        removeFavoriteCalled = true
        favorites.removeAll(where: { $0.login == login })
    }
    
    func getFavorites() -> [User] {
        getFavoritesCalled = true
        return favorites
    }
    
    func isUserFavorite(login: String) -> Bool {
        isUserFavoriteCalled = true
        return favorites.contains(where: { $0.login == login })
    }
}
