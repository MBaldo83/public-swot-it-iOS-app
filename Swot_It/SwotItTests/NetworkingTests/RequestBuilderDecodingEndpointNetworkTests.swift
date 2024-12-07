import XCTest
@testable import Swot_It

class RequestBuilderDecodingEndpointNetworkTests: XCTestCase {
    var mockRequestBuilder: MockRequestBuilder!
    var mockDecodingNetworkLayer: MockDecodingNetworkLayer!
    var sut: RequestBuilderDecodingEndpointNetwork!

    override func setUp() {
        super.setUp()
        mockRequestBuilder = MockRequestBuilder()
        mockDecodingNetworkLayer = MockDecodingNetworkLayer()
        sut = RequestBuilderDecodingEndpointNetwork(requestBuilder: mockRequestBuilder, networkLayer: mockDecodingNetworkLayer)
    }

    func testSendWithValidRequest() async {
        // Given
        let endpoint = MockEndpoint(path: "/test", method: .get, urlComponents: [:], headers: [:], httpBody: nil)
        let expectedData = SampleData(id: 1, name: "Test")
        mockRequestBuilder.customRequest = URLRequest(url: URL(string: "https://example.com/test")!)
        mockDecodingNetworkLayer.result = .success(expectedData)

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(endpoint, decodeTo: SampleData.self)

        // Then
        switch result {
        case .success(let data):
            XCTAssertEqual(data, expectedData)
        case .failure:
            XCTFail("Expected successful decoding, but got failure")
        }
    }

    func testSendWithInvalidRequest() async {
        // Given
        let endpoint = MockEndpoint(path: "/test", method: .get, urlComponents: [:], headers: [:], httpBody: nil)
        mockRequestBuilder.customRequest = nil

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(endpoint, decodeTo: SampleData.self)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure due to bad URL, but got success")
        case .failure(let error):
            if case .badURL = error {
                // Success
            } else {
                XCTFail("Expected bad URL error, but got different error")
            }
        }
    }
}
