import XCTest
@testable import Swot_It

final class IdentityUseCaseProfileViewHandlerTests: XCTestCase {
    
    private var sut: IdentityUseCaseProfileViewHandler!
    private var mockIdentityManagementUseCase: MockIdentityManagementUseCase!

    override func setUp() {
        super.setUp()
        mockIdentityManagementUseCase = MockIdentityManagementUseCase()
        sut = IdentityUseCaseProfileViewHandler(identityManagementUseCase: mockIdentityManagementUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockIdentityManagementUseCase = nil
        super.tearDown()
    }

    func testOnViewAppearLoadsIdentity() async {
        //Arrange
        let exp = expectation(description: "onViewAppear")
        mockIdentityManagementUseCase.completion = {
            exp.fulfill()
        }
        
        //Act
        sut.onViewAppear()
        
        //Assert
        await fulfillment(of: [exp], timeout: 1)
        XCTAssertTrue(mockIdentityManagementUseCase.loadIdentityCalled)
    }

    func testAccessTokenSavedSavesIdentity() async {
        //Arrange
        let exp = expectation(description: "accessTokenSaved")
        mockIdentityManagementUseCase.completion = {
            exp.fulfill()
        }
        //Act
        sut.accessTokenSaved()
        
        //Assert
        await fulfillment(of: [exp], timeout: 1)
        XCTAssertTrue(mockIdentityManagementUseCase.saveIdentityCalled)
    }
}
