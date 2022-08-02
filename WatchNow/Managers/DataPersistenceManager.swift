//
//  DataPersistenceManager.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 24/7/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToEraseData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average ?? 0
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
}

extension DataPersistenceManager {
    func fetchingMoviesFromDatabase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteMovieFromDataBase(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(DatabaseError.failedToEraseData)
        }
    }
}
