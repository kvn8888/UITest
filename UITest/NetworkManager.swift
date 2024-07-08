//
//  NetworkManager.swift
//  UITest
//
//  Created by Kevin Chen on 7/7/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://api.groq.com/openai/v1/chat/completions")!

    func fetchChatResponse(for requestModel: ChatRequest, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")  // Replace YOUR_API_KEY with the actual key

        do {
            request.httpBody = try JSONEncoder().encode(requestModel)
        } catch let error {
            completion(.failure(error))
            return
        }

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was nil"])))
                return
            }

            do {
                let apiResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                completion(.success(apiResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }.resume()
    }
}
