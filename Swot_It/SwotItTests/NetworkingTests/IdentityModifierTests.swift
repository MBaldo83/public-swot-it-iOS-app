import XCTest
@testable import Swot_It

class IdentityModifierTests: XCTestCase {
    var mockIdentity: MockIdentity!
    var mockDecodingNetworkLayer: MockDecodingNetworkLayer!
    var sut: IdentityModifier!

    override func setUp() {
        super.setUp()
        mockIdentity = MockIdentity()
        mockDecodingNetworkLayer = MockDecodingNetworkLayer()
        sut = IdentityModifier(identity: mockIdentity)
    }

    func testSuccessfulRequestWithAccessToken() async {
        // Given
        mockIdentity.currentAccessToken = "valid_token"
        mockDecodingNetworkLayer.result = .success(SampleData(id: 1, name: "Test"))

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(request: URLRequest(url: URL(string: "https://example.com")!), upstream: mockDecodingNetworkLayer, decodeTo: SampleData.self)

        // Then
        XCTAssertEqual(mockDecodingNetworkLayer.lastRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer valid_token")
        switch result {
        case .success(let data):
            XCTAssertEqual(data, SampleData(id: 1, name: "Test"))
        case .failure:
            XCTFail("Expected successful request, but got failure")
        }
    }

    func testRequestFailsWithoutAccessToken() async {
        // Given
        mockIdentity.currentAccessToken = nil

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(request: URLRequest(url: URL(string: "https://example.com")!), upstream: mockDecodingNetworkLayer, decodeTo: SampleData.self)

        // Then
        guard case .failure(.notAuthenticated) = result else {
            XCTFail("Expected notAuthenticated failure due to missing access token, but got success or unexpected error")
            return
        }
    }
}
