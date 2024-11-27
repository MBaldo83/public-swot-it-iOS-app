import Foundation

// TODO This should be simply Deck, and only available once it's been saved
struct APISavedDeck: Equatable {
    let apiId: String
    var topic: String // Change to Sanitized topic?
    var questionSet: [Question]
    
    // These will be deleted after the mode re-factor
    struct SanitizedQuestionCount {
        let count: Int
        
        init?(count: Int) {
            guard count >= 1 && count <= 10 else {
                return nil // Initialization fails if count is out of range
            }
            self.count = count
        }
    }
    
    // These will be deleted after the mode re-factor
    struct SanitizedTopic: Equatable {
        let topic: String
        
        // Failable initializer
        init?(topic: String) {
            
            // TODO - make this based on regex
            guard topic.count >= 1 && topic.count <= 100 else {
                return nil // Initialization fails if the question length is out of range
            }
            self.topic = topic
        }
    }
}

struct APISavedDeckSummary: Equatable, Identifiable, Hashable {
    let apiId: String
    var topic: String
    var id: String {
        apiId
    }
}
