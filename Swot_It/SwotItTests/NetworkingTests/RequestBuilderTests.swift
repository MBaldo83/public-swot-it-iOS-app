import XCTest
@testable import Swot_It

class RequestBuilderTests: XCTestCase {
    var mockBaseURLProvider: MockBaseURLProvider!
    var sut: RequestBuilder!

    override func setUp() {
        super.setUp()
        mockBaseURLProvider = MockBaseURLProvider()
        sut = RequestBuilder(baseURLProvider: mockBaseURLProvider)
    }

    func testBuildRequestWithHTTPBody() {
        // Given
        mockBaseURLProvider.customBaseURL = URL(string: "https://example.com")
        let httpBodyData = "Test Body".data(using: .utf8)
        let endpoint = MockEndpoint(path: "/test", method: .post, urlComponents: [:], headers: [:], httpBody: httpBodyData)

        // When
        let request = sut.buildRequest(from: endpoint)

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, httpBodyData)
    }

    func testBuildRequestWithValidBaseURL() {
        // Given
        mockBaseURLProvider.customBaseURL = URL(string: "https://example.com")
        let endpoint = MockEndpoint(path: "/test", method: .get, urlComponents: ["key": "value"], headers: ["Header": "Value"], httpBody: nil)

        // When
        let request = sut.buildRequest(from: endpoint)

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://example.com/test?key=value")
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Header"), "Value")
    }

    func testBuildRequestWithInvalidBaseURL() {
        // Given
        mockBaseURLProvider.customBaseURL = nil
        let endpoint = MockEndpoint(path: "/test", method: .get, urlComponents: [:], headers: [:], httpBody: nil)

        // When
        let request = sut.buildRequest(from: endpoint)

        // Then
        XCTAssertNil(request)
    }
}

struct MockEndpoint: Endpoint {
    var path: String
    var method: HTTPMethod
    var urlComponents: [String: String]
    var headers: [String: String]
    var httpBody: Data?
}
