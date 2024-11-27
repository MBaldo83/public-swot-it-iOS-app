import XCTest
import ConcurrencyExtras
@testable import Swot_It

class SwotItModelTests: XCTestCase {

    func testGenerateCardsSuccess() async throws {
        
        await withMainSerialExecutor {
            let mockAPIClient = MockDecksAPIClient()
            mockAPIClient.generateCardsResult = {
                await Task.yield()
                return .success([Question(question: "Sample Question", answer: "Sample Answer")])
            }
            
            let model = await SwotItModel(apiClient: mockAPIClient, identity: MockIdentity())
            
            let task = Task {
                await model.generateCards(for: APISavedDeck.SanitizedTopic(topic: "Sample")!, count: APISavedDeck.SanitizedQuestionCount(count: 1)!)
            }
            
            await Task.yield()
            
            let state = await model.deckGeneratorCurrentDeck
            XCTAssertEqual(state, .loading)
            
            await task.value
            
            if case .loaded(let deck) = await model.deckGeneratorCurrentDeck {
                XCTAssertEqual(deck.questionSet.count, 1)
                XCTAssertEqual(deck.questionSet.first?.question, "Sample Question")
                XCTAssertEqual(deck.questionSet.first?.answer, "Sample Answer")
            } else {
                XCTFail("Expected deckGeneratorCurrentDeck to be loaded")
            }
        }
    }

    func testGenerateCardsFailure() async throws {
        
        await withMainSerialExecutor {
            let mockAPIClient = MockDecksAPIClient()
            mockAPIClient.generateCardsResult = {
                await Task.yield()
                return .failure(.systemError)
            }
            
            let model = await SwotItModel(apiClient: mockAPIClient, identity: MockIdentity())
            
            let task = Task {
                await model.generateCards(for: APISavedDeck.SanitizedTopic(topic: "Sample")!, count: APISavedDeck.SanitizedQuestionCount(count: 1)!)
            }
            
            await Task.yield()
            
            let state = await model.deckGeneratorCurrentDeck
            XCTAssertEqual(state, .loading)
            
            await task.value
            
            if case .error(let error) = await model.deckGeneratorCurrentDeck {
                XCTAssertEqual(error, .systemError)
            } else {
                XCTFail("Expected deckGeneratorCurrentDeck to be failed with networkError")
            }
        }
    }
}

class MockDecksAPIClient: DecksAPIClient {
    var generateCardsResult: () async -> Result<[Question], LoadableResourceError> = { .success([]) }

    func generateCards(topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) async -> Result<[Question], LoadableResourceError> {
        return await generateCardsResult()
    }

    func loadDecks() async throws -> [Deck] {
        return []
    }

    func saveDeck(_ deck: Deck) async -> Result<Deck.APIDeckIdentifier, LoadableResourceError> {
        return .success(.init(id: ""))
    }

    func updateDeck(_ deck: Deck, apiId: Deck.APIDeckIdentifier) async -> Result<Deck.APIDeckIdentifier, LoadableResourceError> {
        return .success(apiId)
    }
}

class MockIdentity: Identity {
    var currentAccessToken: String?
}
