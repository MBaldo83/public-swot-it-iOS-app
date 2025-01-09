import XCTest
@testable import Swot_It

final class ResourceManagingDeckGeneratorViewHandlerTests: XCTestCase {
    
    private var sut: ResourceManagingDeckGeneratorViewHandler!
    private var mockCardGeneratorUseCase: MockCardGeneratorUseCase!
    private var mockDeckResourceManagementUseCase: MockDeckResourceManagementUseCase!

    override func setUp() {
        super.setUp()
        mockCardGeneratorUseCase = MockCardGeneratorUseCase()
        mockDeckResourceManagementUseCase = MockDeckResourceManagementUseCase()
        sut = ResourceManagingDeckGeneratorViewHandler(
            cardGenerator: mockCardGeneratorUseCase,
            deckResourceManagementUseCase: mockDeckResourceManagementUseCase
        )
    }

    override func tearDown() {
        sut = nil
        mockCardGeneratorUseCase = nil
        mockDeckResourceManagementUseCase = nil
        super.tearDown()
    }

    func testGenerateCardsTappedCallsUseCase() {
        //Arrange
        let topic = QuestionsGenerated.SanitizedTopic(topic: "test")!
        let count = QuestionsGenerated.SanitizedQuestionCount(count: 5)!
        let exp = expectation(description: "generateCardsTapped")
        mockCardGeneratorUseCase.completion = {
            exp.fulfill()
        }

        //Act
        sut.generateCardsTapped(topic: topic, count: count)

        //Assert
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(mockCardGeneratorUseCase.generateCardsCalled)
        XCTAssertEqual(mockCardGeneratorUseCase.topic, topic)
        XCTAssertEqual(mockCardGeneratorUseCase.count, count)
    }

    func testSaveNewDeckCallsUseCase() {
        //Arrange
        let deck = [Question(id: UUID(), question: "test", answer: "test")]
        let topic = QuestionsGenerated.SanitizedTopic(topic: "test")!
        let exp = expectation(description: "saveNewDeck")
        mockDeckResourceManagementUseCase.completion = {
            exp.fulfill()
        }

        //Act
        sut.saveNewDeck(deck, topic: topic)

        //Assert
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(mockDeckResourceManagementUseCase.saveNewDeckCalled)
    }

    func testUpdateDeckCallsUseCase() {
        //Arrange
        let deck = LocalDeck.mock()
        let exp = expectation(description: "updateDeck")
        mockDeckResourceManagementUseCase.completion = {
            exp.fulfill()
        }

        //Act
        sut.updateDeck(deck)

        //Assert
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(mockDeckResourceManagementUseCase.updateLocalDeckCalled)
        XCTAssertEqual(mockDeckResourceManagementUseCase.deck, deck)
    }
}
