import Foundation

protocol ResultsUpdater {
    func updateResults(_ submissions: [QuestionSubmission], forDeckId deckId: UUID) async
}

class ResultsUpdatingDeckReviewViewHandler: DeckReviewViewHandler {
    private let resultsUpdater: ResultsUpdater

    init(resultsUpdater: ResultsUpdater) {
        self.resultsUpdater = resultsUpdater
    }

    func submitSubmissions(_ submissions: [QuestionSubmission], forDeckId deckId: UUID) {
        Task {
            await resultsUpdater.updateResults(submissions, forDeckId: deckId)
        }
    }
}
