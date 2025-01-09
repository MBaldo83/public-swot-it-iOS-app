import Foundation
@testable import Swot_It

class MockIdentityManagementUseCase: IdentityManagementUseCase {
    var loadIdentityCalled = false
    var saveIdentityCalled = false
    var completion: () -> Void = { }

    func loadIdentity() async {
        loadIdentityCalled = true
        completion()
    }

    func saveIdentity() async {
        saveIdentityCalled = true
        completion()
    }
}

class MockDeckResourceManagementUseCase: DeckResourceManagementUseCase {
    
    var completion: () -> Void = {}

    var updateLocalDeckCalled = false
    var deck: LocalDeck?
    func updateLocalDeck(
        _ deck: LocalDeck
    ) async {
        updateLocalDeckCalled = true
        self.deck = deck
        completion()
    }
    
    var saveNewDeckCalled = false
    var savedNewDeck: [Swot_It.Question]?
    var savedTopic: Swot_It.QuestionsGenerated.SanitizedTopic?
    func saveNewDeck(
        _ deck: [Swot_It.Question],
        topic: Swot_It.QuestionsGenerated.SanitizedTopic
    ) async {
        saveNewDeckCalled = true
        self.savedNewDeck = deck
        self.savedTopic = topic
        completion()
    }
}

class MockLoadDecksUseCase: LoadDecksUseCase {
    var loadDecksCalled = false
    var completion: () -> Void = {}

    func loadDecks() async {
        loadDecksCalled = true
        completion()
    }
}

class MockCardGeneratorUseCase: CardGeneratorUseCase {
    var generateCardsCalled = false
    var topic: QuestionsGenerated.SanitizedTopic?
    var count: QuestionsGenerated.SanitizedQuestionCount?
    var completion: () -> Void = {}

    func generateCards(for topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount) async {
        generateCardsCalled = true
        self.topic = topic
        self.count = count
        completion()
    }
}

class MockResultsUpdater: ResultsUpdater {
    var updateResultsCalled = false
    var submissions: [QuestionSubmission]?
    var deckId: UUID?
    var completion: () -> Void = {}

    func updateResults(_ submissions: [QuestionSubmission], forDeckId deckId: UUID) async {
        updateResultsCalled = true
        self.submissions = submissions
        self.deckId = deckId
        completion()
    }
}
