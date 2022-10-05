//
//  NetworkManager.swift
//  testWorkLimex
//
//  Created by Никита Ананьев on 01.10.2022.
//

import Foundation

struct NetworkManager {
    
    enum NetworkFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func fetchChannels() async throws -> [Channel] {
        
        let channels: [Channel] = try await withCheckedThrowingContinuation({ continuation in
            fetchChannels { result in
                switch result {
                case .success(let channels):
                    continuation.resume(returning: channels)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                
            }
        })
        return channels
    }
    
    static func fetchChannels(completion: @escaping (Result<[Channel], Error>) -> Void) {
        
        guard let url = URL(string: "https://limehd.online/playlist/channels.json") else {
            completion(.failure(NetworkFetcherError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkFetcherError.missingData))
                return
            }
            
            do {
                
                let iTunesResult = try JSONDecoder().decode(ResultJson.self, from: data)
                completion(.success(iTunesResult.channels))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription )
            }
            
        }.resume()
        
    }
    
}
