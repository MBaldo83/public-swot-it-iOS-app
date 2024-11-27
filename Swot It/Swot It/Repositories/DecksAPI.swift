import Foundation

enum DecksAPI: Endpoint {
    case generate(topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount)
    case loadDecks
    case save(deck: DeckNetworkModel)
    case loadDeck(id: String)
    case update(deck: DeckNetworkModel, identifier: DeckIdentifier)
    
    var path: String {
        switch self {
        case .generate:
            return "/v1/decks/generate"
        case .save, .loadDecks:
            return "/v1/decks"
        case .update(_, let identifier):
            return "/v1/decks/\(identifier.id)"
        case .loadDeck(let id):
            return "/v1/decks/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .generate, .save:
            return .post
        case .update:
            return .put
        case .loadDecks:
            return .get
        case .loadDeck:
            return .get
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
        case .loadDecks, .save, .update, .loadDeck:
            return [:]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .save, .update:
            return ["Content-Type": "application/json", "accept": "application/json"]
        case .loadDecks, .generate, .loadDeck:
            return [:]
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .save(let deck), .update(let deck, _):
            return try? JSONEncoder().encode(deck)
        case .loadDecks, .generate, .loadDeck:
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
    
    struct DeckListNetworkModel: Codable {
        let topic: String
        let id: String
    }
    
    struct DeckIdentifier: Decodable {
        let id: String
    }
}
