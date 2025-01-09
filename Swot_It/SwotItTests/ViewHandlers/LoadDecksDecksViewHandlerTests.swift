import XCTest
@testable import Swot_It

final class LoadDecksDecksViewHandlerTests: XCTestCase {

    private var sut: LoadDecksDecksViewHandler!
    private var mockLoadDecksUseCase: MockLoadDecksUseCase!

    override func setUp() {
        super.setUp()
        mockLoadDecksUseCase = MockLoadDecksUseCase()
        sut = LoadDecksDecksViewHandler(loadDecksUseCase: mockLoadDecksUseCase)
    }

    override func tearDown() {
        sut = nil
        mockLoadDecksUseCase = nil
        super.tearDown()
    }

    func testOnAppearCallsUseCase() {
        //Arrange
        let exp = expectation(description: "onAppear")
        mockLoadDecksUseCase.completion = {
            exp.fulfill()
        }

        //Act
        sut.onAppear()

        //Assert
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(mockLoadDecksUseCase.loadDecksCalled)
    }
}
