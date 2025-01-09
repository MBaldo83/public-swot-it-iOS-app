import XCTest
@testable import Swot_It

final class ResultsUpdatingDeckReviewViewHandlerTests: XCTestCase {

    private var sut: ResultsUpdatingDeckReviewViewHandler!
    private var mockResultsUpdater: MockResultsUpdater!

    override func setUp() {
        super.setUp()
        mockResultsUpdater = MockResultsUpdater()
        sut = ResultsUpdatingDeckReviewViewHandler(resultsUpdater: mockResultsUpdater)
    }

    override func tearDown() {
        sut = nil
        mockResultsUpdater = nil
        super.tearDown()
    }

    func testSubmitSubmissionsCallsUseCase() {
        //Arrange
        let submissions: [QuestionSubmission] = [
            QuestionSubmission.mock(submission: .mock(result: .correct)),
            QuestionSubmission.mock(submission: .mock(result: .incorrect))
        ]
        let deckId = UUID()
        let exp = expectation(description: "submitSubmissions")
        mockResultsUpdater.completion = {
            exp.fulfill()
        }

        //Act
        sut.submitSubmissions(submissions, forDeckId: deckId)
        wait(for: [exp], timeout: 1)
        
        //Assert
        XCTAssertTrue(mockResultsUpdater.updateResultsCalled)
        XCTAssertEqual(mockResultsUpdater.submissions, submissions)
        XCTAssertEqual(mockResultsUpdater.deckId, deckId)
    }
}
