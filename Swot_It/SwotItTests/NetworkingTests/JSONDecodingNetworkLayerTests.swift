import XCTest
@testable import Swot_It

class JSONDecodingNetworkLayerTests: XCTestCase {
    var mockNetworkLayer: MockNetworkLayer!
    var sut: JSONDecodingNetworkLayer!

    override func setUp() {
        super.setUp()
        mockNetworkLayer = MockNetworkLayer()
        sut = JSONDecodingNetworkLayer(wrapping: mockNetworkLayer)
    }

    func testSuccessfulDecoding() async {
        // Given
        let jsonData = """
        {
            "id": 1,
            "name": "Test"
        }
        """.data(using: .utf8)!
        mockNetworkLayer.result = .success(jsonData)

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(URLRequest(url: URL(string: "https://example.com")!), decodeTo: SampleData.self)

        // Then
        switch result {
        case .success(let data):
            XCTAssertEqual(data, SampleData(id: 1, name: "Test"))
        case .failure:
            XCTFail("Expected successful decoding, but got failure")
        }
    }

    func testDecodingError() async {
        // Given
        let invalidJsonData = "invalid json".data(using: .utf8)!
        mockNetworkLayer.result = .success(invalidJsonData)

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(URLRequest(url: URL(string: "https://example.com")!), decodeTo: SampleData.self)

        // Then
        switch result {
        case .success:
            XCTFail("Expected decoding error, but got success")
        case .failure(let error):
            if case .decodingError = error {
                // Success
            } else {
                XCTFail("Expected decoding error, but got different error")
            }
        }
    }

    func testRequestError() async {
        // Given
        mockNetworkLayer.result = .failure(.unexpectedResponse)

        // When
        let result: Result<SampleData, NetworkIntegrationError> = await sut.send(URLRequest(url: URL(string: "https://example.com")!), decodeTo: SampleData.self)

        // Then
        switch result {
        case .success:
            XCTFail("Expected request error, but got success")
        case .failure(let error):
            if case .requestError = error {
                // Success
            } else {
                XCTFail("Expected decoding error, but got different error")
            }
        }
    }
}
