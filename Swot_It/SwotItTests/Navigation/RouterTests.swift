import XCTest
import SwiftUI
@testable import Swot_It

final class RouterTests: XCTestCase {
    
    final class DeckDetailViewHandlerNoOpMock: DeckDetailViewHandler {
        func updatedDeck(_ deck: Swot_It.LocalDeck) { }
    }
    
    final class DeckReviewViewHandlerNoOpMock: DeckReviewViewHandler {
        func submitSubmissions(_ submissions: [Swot_It.QuestionSubmission], forDeckId deckId: UUID) {}
    }

    private var sut: Router! // system under test
    private var mockRouteViewBuilder: SwiftUIRouteViewBuilder!

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        
        mockRouteViewBuilder = SwiftUIRouteViewBuilder(
            deckDetailViewHandler: { DeckDetailViewHandlerNoOpMock() },
            deckReviewViewHandler: { DeckReviewViewHandlerNoOpMock() }
        )
        sut = Router(routeViewBuilder: mockRouteViewBuilder)
    }

    @MainActor
    func test_navigateTo_appendsRouteToRoutePath() async throws {
        // Given
        let newRoute = Router.Route.deckDetail(.mock())

        // When
        sut.navigateTo(newRoute)

        // Then
        XCTAssertEqual(sut.routePath, [newRoute])
    }

    @MainActor
    func test_view_returnsViewFromRouteViewBuilder() async throws {
        // Given
        let route = Router.Route.deckDetail(.mock())

        // When
        let returnedView = sut.view(for: route)
        print("returned view: \(returnedView)")

        // Then
        XCTAssert(returnedView is AnyView)
    }
}
