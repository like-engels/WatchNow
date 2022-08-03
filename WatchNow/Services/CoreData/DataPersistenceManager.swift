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
    
    enum CoreDataError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToEraseData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(movie.id)
        item.original_name = movie.original_name
        item.original_title = movie.original_title
        item.overview = movie.overview
        item.poster_path = movie.poster_path
        item.release_date = movie.release_date
        item.vote_average = movie.vote_average ?? 0
        item.vote_count = Int64(movie.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(CoreDataError.failedToSaveData))
        }
    }
}

extension DataPersistenceManager {
    func fetchingMoviesFromCoreData(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(CoreDataError.failedToFetchData))
        }
    }
    
    func deleteMovieFromCoreData(movie: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(movie)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(CoreDataError.failedToEraseData)
        }
    }
}
