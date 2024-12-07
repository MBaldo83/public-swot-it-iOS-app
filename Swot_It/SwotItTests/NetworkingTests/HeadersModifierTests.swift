import XCTest
@testable import Swot_It

class HeadersModifierTests: XCTestCase {
    var mockDecodingNetworkLayer: MockDecodingNetworkLayer!
    var sut: HeadersModifier!

    override func setUp() {
        super.setUp()
        mockDecodingNetworkLayer = MockDecodingNetworkLayer()
        sut = HeadersModifier(headers: ["Authorization": "Bearer token"])
        mockDecodingNetworkLayer.result = .success(SampleData(id: 1, name: "Test"))
    }

    func testHeadersAreAddedToRequest() async {
        // Given
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let expectedHeader = "Bearer token"

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(request: request, upstream: mockDecodingNetworkLayer, decodeTo: SampleData.self)

        // Then
        XCTAssertEqual(mockDecodingNetworkLayer.lastRequest?.value(forHTTPHeaderField: "Authorization"), expectedHeader)
        switch result {
        case .success(let data):
            XCTAssertEqual(data, SampleData(id: 1, name: "Test"))
        case .failure:
            XCTFail("Expected successful decoding, but got failure")
        }
    }

    func testRequestErrorPropagation() async {
        // Given
        mockDecodingNetworkLayer.result = .failure(.requestError(.unexpectedResponse))

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(request: URLRequest(url: URL(string: "https://example.com")!), upstream: mockDecodingNetworkLayer, decodeTo: SampleData.self)

        // Then
        switch result {
        case .success:
            XCTFail("Expected request error, but got success")
        case .failure(let error):
            if case .requestError = error {
                // Success
            } else {
                XCTFail("Expected request error, but got different error")
            }
        }
    }
}
