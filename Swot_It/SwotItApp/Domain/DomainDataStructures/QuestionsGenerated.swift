import Foundation

struct QuestionsGenerated: Equatable {
    let topic: QuestionsGenerated.SanitizedTopic
    let questions: [Question]
    
    struct SanitizedQuestionCount: Equatable {
        let count: Int
        init?(count: Int) {
            guard count >= 1 && count <= 10 else {
                return nil // Initialization fails if count is out of range
            }
            self.count = count
        }
    }
    
    struct SanitizedTopic: Equatable {
        let topic: String
        init?(topic: String) {
            
            // TODO - make this based on regex
            guard topic.count >= 1 && topic.count <= 100 else {
                return nil // Initialization fails if the question length is out of range
            }
            self.topic = topic
        }
    }
}
