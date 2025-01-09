import Foundation
@testable import Swot_It

extension QuestionsGenerated {
    static func mock(
        topic: SanitizedTopic = QuestionsGenerated.SanitizedTopic(topic: "mock")!,
        questions: [Question] = []
    ) -> QuestionsGenerated {
        QuestionsGenerated(
            topic: topic,
            questions: questions
        )
    }
}
