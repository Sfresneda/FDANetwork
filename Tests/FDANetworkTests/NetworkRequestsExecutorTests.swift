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

    func test_execute_logAnErrorWhenTryToBuildRequest() async throws {
        // Given
        let request = NetworkRequestMock(url: "💀", type: .get)
        var model: ExampleModel?

        // When
        do {
            model = try await sut.execute(request: request)
            XCTFail("Unexpected behavior")
        } catch {

            // Then
            XCTAssertEqual(error as NSError, request.urlError)
            XCTAssertFalse(logger.storedLogs.isEmpty)
            XCTAssertEqual(logger.storedLogs.last?.category, NetworkLoggerCategory.error)
        }
        XCTAssertNil(model)
    }


//    func test_post_shouldThrowNoResponseError() async {
//        // Given
//        let request = NetworkRequestMock(url: url, type: .get)
//
//        session.response = HTTPURLResponse(url: try! request.url,
//                                           statusCode: 200,
//                                           httpVersion: nil,
//                                           headerFields: nil)
//        session.error = NetworkAPIError.noResponse
//
//        // When
//        sut = NetworkRequestsExecutor(session: session, logger: nil)
//
//        do {
//            let model: ExampleModel? = try await sut.execute(request: request)
//            XCTAssertNil(model)
//        } catch {
//            // Then
//            XCTAssertEqual(error as! NetworkAPIError, NetworkAPIError.noResponse)
//        }
//    }
}
