//
//  DataService.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import Foundation

final class DataService{
    static let shared = DataService()
    
    func getItems(completion: @escaping (Result<[ItemModel], Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([ItemModel].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
}

