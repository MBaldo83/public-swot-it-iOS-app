import Foundation

struct DefaultAiderConfig {
    static let model = LanguageModel.gemini_15Pro
    static let files: [String] = []
    static let readOnly = "AI_CONVENTIONS.md"
    static let chatHistoryID = UUID().uuidString
    
    enum LanguageModel: String {
        case gemini_15Pro = "gemini/gemini-1.5-pro-latest"
        case gpt_4o = "gpt-4o"
    }
}

protocol PromptConfig {
    var filesToAdd: [String] { get }
    var model: String { get }
    var readOnly: String { get }
    var chatHistoryID: String { get }
}

extension PromptConfig {
    var model: String { DefaultAiderConfig.model.rawValue }
    var readOnly: String { DefaultAiderConfig.readOnly }
    
    // Chat history within a session will have the same ID by default
    var chatHistoryID: String { DefaultAiderConfig.chatHistoryID }
    
    // To make it unique by default
    // var chatHistoryID: String { UUID().uuidString }
}
