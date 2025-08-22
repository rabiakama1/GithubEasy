//
//  HomeViewModelTests.swift
//  GithubEasy
//
//  Created by rabiakama on 22.08.2025.
//

import XCTest
@testable import GithubEasy

final class HomeViewModelTests: XCTestCase {

    private var viewModel: HomeViewModel!
    private var mockRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        
        let searchUseCase = SearchUsersUseCase(repository: mockRepository)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: mockRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: mockRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: mockRepository)
        
        viewModel = HomeViewModel(
            searchUsersUseCase: searchUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    

    func test_search_whenApiReturnsUsers_shouldUpdateStateToSuccess() {
        let mockUsers = [User(login: "rabiakama1", avatarUrl: "", profileUrl: "")]
        mockRepository.searchUsersResult = .success(mockUsers)
        
        let expectation = self.expectation(description: "State should be updated to success")
        var finalState: ViewState<[UserItemModel]>?
        
        viewModel.onStateChange = { state in
            if case .success = state {
                finalState = state
                expectation.fulfill()
            }
        }
        
        viewModel.search(query: "test")
        
        waitForExpectations(timeout: 1.0)
        
        guard case .success(let userItems) = finalState else {
            XCTFail("Final state should be success")
            return
        }
        
        XCTAssertEqual(userItems.count, 1)
        XCTAssertEqual(userItems.first?.login, "rabiakama1")
        XCTAssertTrue(mockRepository.searchUsersCalled)
    }
    
    func test_search_whenApiReturnsError_shouldUpdateStateToFailure() {
        mockRepository.searchUsersResult = .failure(TestError.generic)
        
        let expectation = self.expectation(description: "State should be updated to failure")
        var finalState: ViewState<[UserItemModel]>?
        
        viewModel.onStateChange = { state in
            if case .failure = state {
                finalState = state
                expectation.fulfill()
            }
        }
        
        viewModel.search(query: "ra")
        
        waitForExpectations(timeout: 1.0)
        
        guard case .failure(let errorMessage) = finalState else {
            XCTFail("Final state should be failure")
            return
        }
        
        XCTAssertEqual(errorMessage, TestError.generic.localizedDescription)
        XCTAssertTrue(mockRepository.searchUsersCalled)
    }

    func test_search_whenQueryIsEmpty_shouldUpdateStateToEmpty() {
        let expectation = self.expectation(description: "State should be updated to empty")
        var finalState: ViewState<[UserItemModel]>?

        viewModel.onStateChange = { state in
            finalState = state
            expectation.fulfill()
        }

        viewModel.search(query: "")

        waitForExpectations(timeout: 1.0)

        guard case .empty(let message) = finalState else {
            XCTFail("Final state should be empty")
            return
        }

        XCTAssertEqual(message, "Search a user...")
        XCTAssertFalse(mockRepository.searchUsersCalled)
    }
}
