//
//  UserRepositoryProtocol.swift
//  GithubEasy
//
//  Created by rabiakama on 19.08.2025.
//

import Foundation

protocol UserRepositoryProtocol {
    
    /// Verilen bir sorgu ile GitHub'da kullanıcı arar.
    /// - Parameters:
    ///   - query: Aranacak metin.
    ///   - completion: Sonuçları içeren bir `Result` döner. Başarılı olursa `[User]`, başarısız olursa `Error`.
    func searchUsers(query: String, completion: @escaping (Result<[User], Error>) -> Void)
    
    /// Belirli bir kullanıcının detay bilgilerini getirir.
    /// - Parameters:
    ///   - username: Detayları alınacak kullanıcının adı.
    ///   - completion: Sonucu içeren bir `Result` döner. Başarılı olursa `UserDetail`, başarısız olursa `Error`.
    func getUserDetail(username: String, completion: @escaping (Result<UserDetail, Error>) -> Void)
    
    
    // MARK: - Favorites Operations
    
    /// Bir kullanıcıyı favorilere ekler.
    /// - Parameter user: Favorilere eklenecek `User` nesnesi.
    func addFavorite(user: User)
    
    /// Bir kullanıcıyı favorilerden siler.
    /// - Parameter login: Favorilerden silinecek kullanıcının `login` adı.
    func removeFavorite(login: String)
    
    /// Kayıtlı tüm favori kullanıcıları getirir.
    /// - Returns: Favori olarak kaydedilmiş `User` nesnelerinin dizisi.
    func getFavorites() -> [User]
    
    /// Belirli bir kullanıcının favorilerde olup olmadığını kontrol eder.
    /// - Parameter login: Kontrol edilecek kullanıcının `login` adı.
    /// - Returns: Kullanıcı favorilerdeyse `true`, değilse `false`.
    func isUserFavorite(login: String) -> Bool
}
