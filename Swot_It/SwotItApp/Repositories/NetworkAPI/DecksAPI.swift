import Foundation

enum DecksAPI: Endpoint {
    
    case generate(topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount)
    
    var path: String {
        switch self {
        case .generate:
            return "/v1/decks/generate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .generate:
            return .post
        }
    }
    
    var urlComponents: [String: String] {
        switch self {
        case .generate(let topic, let count):
            return [
                "topic": topic.topic,
                "num_questions": String(count.count),
                "mocked": "true"
            ]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .generate:
            return [:]
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .generate:
            return nil
        }
    }
}


extension DecksAPI {
    struct QuestionNetworkModel: Codable {
        let question: String
        let answer: String
    }
    
    struct QuestionSetNetworkModel: Codable {
        let questions: [QuestionNetworkModel]
    }
    
    struct DeckNetworkModel: Codable {
        let topic: String
        let question_set: QuestionSetNetworkModel
    }
}
