import XCTest
@testable import Swot_It

final class LoadDeckUseCaseDeckDetailViewHandlerTests: XCTestCase {

    private var sut: LoadDeckUseCaseDeckDetailViewHandler!
    private var mockDeckResourceManagementUseCase: MockDeckResourceManagementUseCase!

    override func setUp() {
        super.setUp()
        mockDeckResourceManagementUseCase = MockDeckResourceManagementUseCase()
        sut = LoadDeckUseCaseDeckDetailViewHandler(deckResourceManagementUseCase: mockDeckResourceManagementUseCase)
    }

    override func tearDown() {
        sut = nil
        mockDeckResourceManagementUseCase = nil
        super.tearDown()
    }

    func testUpdatedDeckCallsUseCase() async {
        //Arrange
        let exp = expectation(description: "updatedDeck")
        mockDeckResourceManagementUseCase.completion = {
            exp.fulfill()
        }
        let deck = LocalDeck.mock()

        //Act
        sut.updatedDeck(deck)

        //Assert
        await fulfillment(of: [exp], timeout: 1)
        XCTAssertTrue(mockDeckResourceManagementUseCase.updateLocalDeckCalled)
        XCTAssertEqual(mockDeckResourceManagementUseCase.deck, deck)

    }
}
