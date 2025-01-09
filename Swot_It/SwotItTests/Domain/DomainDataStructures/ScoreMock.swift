import Foundation
@testable import Swot_It

extension Score {
    static func mock(
        unanswered: Double = 0,
        incorrect: Double = 0,
        hard: Double = 0,
        correct: Double = 0,
        easy: Double = 0
    ) -> Score {
        Score(
            unanswered: unanswered,
            incorrect: incorrect,
            hard: hard,
            correct: correct,
            easy: easy
        )
    }
}
