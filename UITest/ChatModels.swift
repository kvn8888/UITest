//
//  ChatModels.swift
//  UITest
//
//  Created by Kevin Chen on 7/7/24.
//

import Foundation

// Define the message struct used in the request
struct ChatMessage: Codable, Equatable {
    let role: String
    let content: String
}

// Define the request body structure
struct ChatRequest: Codable, Equatable {
    let messages: [ChatMessage]
    let model: String
    let temperature: Double?
    let max_tokens: Int?
    let top_p: Double?
    let stream: Bool?
}

// Define a simple response structure
struct ChatResponse: Codable, Equatable {
    let id: String?
    let object: String?
    let created: Int?
    let model: String?
    let choices: [ChatChoice]
    let usage: Usage?
}

struct Usage: Codable, Equatable {
    let prompt_tokens: Int?
    let prompt_time: Double?
    let completion_tokens: Int?
    let completion_time: Double?
    let total_tokens: Int?
    let total_time: Double?
}


struct ChatChoice: Codable, Equatable {
    let index: Int?
    let message: ChatMessage
    let logprobs: String?
    let finish_reason: String?
}
