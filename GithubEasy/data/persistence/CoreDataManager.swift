//
//  CoreDataManager.swift
//  GithubEasy
//
//  Created by rabiakama on 18.08.2025.
//

import Foundation
import CoreData

final class CoreDataManager {


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteUsersModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })        
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init() {}

    // Context'te yapılan değişiklikleri veritabanına kalıcı olarak kaydeder
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Uygulamaya Özel Fonksiyonlar
    
    /// Belirtilen kullanıcı favorilerde mi diye kontrol eder.
    func isFavorite(login: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Favori kontrol hatası: \(error)")
            return false
        }
    }
    
    /// Yeni bir kullanıcıyı favorilere ekler.
    func addFavorite(login: String, avatarUrl: String, profileUrl: String) {
        let favoriteUser = FavoriteUser(context: context)
        favoriteUser.login = login
        favoriteUser.avatarURL = avatarUrl
        favoriteUser.htmlURL = profileUrl
        favoriteUser.date = Date()
        print("✅ Favori ekleniyor: \(login)")
        saveContext()
        print("💾 Kayıt işlemi tamamlandı.")
    }
    
    
    /// Bir kullanıcıyı favorilerden siler.
    func deleteFavorite(login: String) {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let userToDelete = results.first {
                context.delete(userToDelete)
                saveContext()
            }
        } catch {
            print("Favori silme hatası: \(error)")
        }
    }

    /// Tüm favori kullanıcıları getirir.
    func fetchAllFavorites() -> [FavoriteUser] {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        
        // En son ekleneni en üstte göstermek için sıralama
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
           return try context.fetch(fetchRequest)
        } catch {
            print("Tüm favorileri getirme hatası: \(error)")
            return []
        }
    }
}
