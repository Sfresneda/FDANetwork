//
//  NetworkRequestsExecutorTests.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import XCTest

final class NetworkRequestsExecutorTests: XCTestCase {

    private let url = "https://sergiofresneda.com"

    var sut: NetworkRequestsExecutor!
    var session: NetworkSessionMock!
    var logger: NetworkLoggerMock!

    override func setUpWithError() throws {
        session = NetworkSessionMock()
        logger = NetworkLoggerMock()
        sut = NetworkRequestsExecutor(session: session, logger: logger)
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        logger = nil
    }

    func test_execute_logAnErrorWhenTryToBuildRequest_throwsAnError() async throws {
        // Given
        let request = NetworkRequestMock(url: "💀", type: .get)
        var result: ExampleModel?

        // When
        do {
            result = try await sut.execute(request: request)
            XCTFail("Unexpected behavior")
        } catch {

            // Then
            XCTAssertFalse(logger.storedLogs.isEmpty)
            XCTAssertEqual(logger.storedLogs.last?.category, NetworkLoggerCategory.error)
        }
        XCTAssertNil(result)
    }

    func test_execute_getRequest_withNilResponse_throwsANonResponseError() async throws {
        // Given
        let model: ExampleModel = ExampleModel(id: 123, name: "Sergio")
        let url: URL = .init(string: "https://sergiofresneda.com")!
        let request = NetworkRequestMock(url: url.absoluteString,
                                         type: .get)
        var result: ExampleModel?
        session.response = URLResponse(url: url,
                                       mimeType: nil,
                                       expectedContentLength: 9,
                                       textEncodingName: nil)
        session.data = model.asDictionary

        // When
        do {
            result = try await sut.execute(request: request)
            XCTFail("Unexpected behavior")
        } catch {
            // Then
            let unwrappedError = try XCTUnwrap(error as? NetworkAPIError)
            XCTAssertEqual(unwrappedError, NetworkAPIError.noResponse)
        }
        XCTAssertNil(result)
    }

    func test_execute_getRequest_withResponse_returnsModel() async throws {
        // Given
        let model: ExampleModel = ExampleModel(id: 123, name: "Sergio")
        let url: URL = .init(string: "https://sergiofresneda.com")!
        let request = NetworkRequestMock(url: url.absoluteString,
                                         type: .get)
        var result: ExampleModel?
        session.response = HTTPURLResponse(url: url,
                                           mimeType: nil,
                                           expectedContentLength: 9,
                                           textEncodingName: nil)
        session.data = model.asDictionary

        // When
        do {
            result = try await sut.execute(request: request)
        } catch {
            // Then
            XCTFail("Unexpected behavior")
        }
        XCTAssertNotNil(result)
        XCTAssertEqual(result, model)
    }

    func test_execute_getRequestWithParams_withResponse_returnsModel() async throws {
        // Given
        let model: ExampleModel = ExampleModel(id: 123, name: "Sergio")
        let url: URL = .init(string: "https://sergiofresneda.com")!
        var request = NetworkRequestMock(url: url.absoluteString,
                                         type: .get)
        request._queryItems = ["foo": "bar"]

        var result: ExampleModel?
        session.response = HTTPURLResponse(url: url,
                                           mimeType: nil,
                                           expectedContentLength: 9,
                                           textEncodingName: nil)
        session.data = model.asDictionary

        // When
        do {
            result = try await sut.execute(request: request)
        } catch {
            // Then
            XCTFail("Unexpected behavior")
        }
        XCTAssertNotNil(result)
        XCTAssertEqual(result, model)
    }

    func test_execute_getRequestWithParamsAndHeader_withResponse_returnsModel() async throws {
        // Given
        let model: ExampleModel = ExampleModel(id: 123, name: "Sergio")
        let url: URL = .init(string: "https://sergiofresneda.com")!
        var request = NetworkRequestMock(url: url.absoluteString,
                                         type: .get)
        request._queryItems = ["foo": "bar"]
        request._headers = ["foo": "bar"]

        var result: ExampleModel?
        session.response = HTTPURLResponse(url: url,
                                           mimeType: nil,
                                           expectedContentLength: 9,
                                           textEncodingName: nil)
        session.data = model.asDictionary

        // When
        do {
            result = try await sut.execute(request: request)
        } catch {
            // Then
            XCTFail("Unexpected behavior")
        }
        XCTAssertNotNil(result)
        XCTAssertEqual(result, model)
    }

    func test_execute_getRequestWithParamsAndHeader_withError404Response_returnsModel() async throws {
        // Given
        let model: ExampleModel = ExampleModel(id: 123, name: "Sergio")
        let url: URL = .init(string: "https://sergiofresneda.com")!
        let statusCode: Int = 404
        let expectedError = NetworkAPIError(statusCode: statusCode,
                                            rawError: "")
        var request = NetworkRequestMock(url: url.absoluteString,
                                         type: .get)
        request._queryItems = ["foo": "bar"]
        request._headers = ["foo": "bar"]

        var result: ExampleModel?
        session.response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.data = model.asDictionary

        // When
        do {
            result = try await sut.execute(request: request)
            XCTFail("Unexpected behavior")
        } catch {
            // Then
            let unwrappedError = try XCTUnwrap(error as? NetworkAPIError)
            XCTAssertEqual(expectedError, unwrappedError)
        }
        XCTAssertNil(result)
    }


}
