//
//  NetworkEndpointExecutorTests.swift
//
//  Created by Sergio Fresneda on 11/10/23.
//

@testable import FDANetwork
import XCTest

final class NetworkEndpointExecutorTests: XCTestCase {

    var sut: NetworkEndpointExecutor!
    var session: NetworkSessionMock!
    var logger: NetworkLoggerMock!
    let url = URL(string: "https://sergiofresneda.com")!

    override func setUpWithError() throws {
        session = NetworkSessionMock()
        logger = NetworkLoggerMock()
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        logger = nil
    }

    // MARK: GET
    func test_get_shouldThrowNoResponseError() async throws {
        // Given
        let endpoint = NetworkEndpointMock(url: url)
        let request = NetworkRequest.get(endpoint: endpoint)
        let model = NetworkRequestModel(request: request,
                                        body: nil,
                                        params: nil,
                                        headers: nil)
        session.response = HTTPURLResponse(url: endpoint.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.error = NetworkAPIError.noResponse

        // When
        sut = NetworkEndpointExecutor(session: session, logger: nil)

        do {
            let model: ExampleModel? = try await sut.execute(requestModel: model)
            XCTAssertNil(model)
        } catch {
            // Then
            XCTAssertEqual(error as! NetworkAPIError, NetworkAPIError.noResponse)
        }
    }

    func test_get_withData_shouldReturnModel() async {
        // Given
        let data = ExampleModel(id: 1, name: "Sergio").asDictionary
        let endpoint = NetworkEndpointMock(url: url)
        let request = NetworkRequest.get(endpoint: endpoint)
        let model = NetworkRequestModel(request: request,
                                        body: nil,
                                        params: nil,
                                        headers: nil)
        session.response = HTTPURLResponse(url: endpoint.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.data = data

        // When
        sut = NetworkEndpointExecutor(session: session, logger: nil)

        do {
            let model: ExampleModel? = try await sut.execute(requestModel: model)
            // Then
            XCTAssertNotNil(model)
        } catch {
            XCTFail("Should not throw error")
        }
    }

    func tests_get_withoutData_shouldThrowAnError() async {
        // Given
        let notFoundError: NetworkAPIError = NetworkAPIError(statusCode: 404, detail: "Not found")
        let endpoint = NetworkEndpointMock(url: url)
        let request = NetworkRequest.get(endpoint: endpoint)
        let model = NetworkRequestModel(request: request,
                                        body: nil,
                                        params: nil,
                                        headers: nil)
        session.response = HTTPURLResponse(url: endpoint.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.error = notFoundError
        session.data = nil

        // When
        sut = NetworkEndpointExecutor(session: session, logger: nil)

        do {
            let model: ExampleModel? = try await sut.execute(requestModel: model)
            XCTAssertNil(model)
        } catch {
            // Then
            XCTAssertEqual(error as! NetworkAPIError, notFoundError)
        }
    }

    // MARK: POST
    func test_post_shouldThrowNoResponseError() async {
        // Given
        let endpoint = NetworkEndpointMock(url: url)
        let request = NetworkRequest.post(endpoint: endpoint)
        let model = NetworkRequestModel(request: request,
                                        body: nil,
                                        params: nil,
                                        headers: nil)
        session.response = HTTPURLResponse(url: endpoint.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
        session.error = NetworkAPIError.noResponse

        // When
        sut = NetworkEndpointExecutor(session: session, logger: nil)

        do {
            let model: ExampleModel? = try await sut.execute(requestModel: model)
            XCTAssertNil(model)
        } catch {
            // Then
            XCTAssertEqual(error as! NetworkAPIError, NetworkAPIError.noResponse)
        }
    }
    
    func test_post_withData_shouldReturnModel() async {

    }

    func tests_post_withoutData_shouldThrowAnError() async {

    }
}
