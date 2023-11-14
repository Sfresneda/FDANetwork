//
//  FDARequestTests.swift
//  
//
//  Created by Sergio Fresneda on 2/11/23.
//

import XCTest
@testable import FDANetwork

final class FDARequestTests: XCTestCase {
    let baseUrl = "https://sergiofresneda.com/"
    let routeComponent1 = "test"
    let routeComponent2 = "test2"
    let headers: [String: String] = ["header1": "value1", "header2": "value2"]
    let queryItems: [String: Any] = ["query1": "value1", "query2": "value2"]
    let body: [String: Any] = ["body1": "value1", "body2": "value2"]

    // MARK: GET

    func test_get_request_withoutHeadersQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .get(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.get)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
    }

    func test_get_request_withHeaders_withoutQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .get(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.get)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
    }

    func test_get_request_withHeadersAndQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .get(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.get)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
    }

    // MARK: POST

    func test_post_request_withoutHeadersQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .post(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.post)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
    }

    func test_post_request_withHeaders_withoutQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .post(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.post)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
    }

    func test_post_request_withHeadersAndQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .post(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.post)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
    }

    func test_post_request_withHeadersQueryItemsAndBody() throws {
        // Given

        // When
        let request = FDARequest
            .post(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)
            .body(body)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.post)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
        XCTAssertEqual(request.body?.asJson, body.asJson)
    }

    // MARK: PATCH

    func test_patch_request_withoutHeadersQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .patch(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.patch)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
    }

    func test_patch_request_withHeaders_withoutQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .patch(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.patch)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
    }

    func test_patch_request_withHeadersAndQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .patch(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.patch)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
    }

    func test_patch_request_withHeadersQueryItemsAndBody() throws {
        // Given

        // When
        let request = FDARequest
            .patch(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)
            .body(body)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.patch)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
        XCTAssertEqual(request.body?.asJson, body.asJson)
    }

    // MARK: PUT

    func test_put_request_withoutHeadersQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .put(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.put)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
    }

    func test_put_request_withHeaders_withoutQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .put(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.put)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
    }

    func test_put_request_withHeadersAndQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .put(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.put)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
    }

    func test_put_request_withHeadersQueryItemsAndBody() throws {
        // Given

        // When
        let request = FDARequest
            .put(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)
            .body(body)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.put)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
        XCTAssertEqual(request.body?.asJson, body.asJson)
    }

    // MARK: DELETE

    func test_delete_request_withoutHeadersQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .delete(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.delete)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
    }

    func test_delete_request_withHeaders_withoutQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .delete(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.delete)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
    }

    func test_delete_request_withHeadersAndQueryItems() throws {
        // Given

        // When
        let request = FDARequest
            .delete(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.delete)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
    }

    func test_delete_request_withHeadersQueryItemsAndBody() throws {
        // Given

        // When
        let request = FDARequest
            .delete(routeComponent1, routeComponent2)
            .baseUrl(baseUrl)
            .headers(headers)
            .queryItems(queryItems)
            .body(body)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.delete)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: baseUrl + "test/test2"))
        XCTAssertEqual(request.headers, headers)
        XCTAssertEqual(request.queryItems?.asJson, queryItems.asJson)
        XCTAssertEqual(request.body?.asJson, body.asJson)
    }

    // MARK: Other
    
    func test_get_request_withoutBaseUrl() throws {
        // Given

        // When
        let request = FDARequest
            .get(routeComponent1, routeComponent2)

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.get)
        let url = try XCTUnwrap(try? request.url)

        XCTAssertEqual(url, URL(string: "test/test2"))
    }

    func test_get_request_withBarUrl_shouldThrow() throws {
        // Given

        // When
        let request = FDARequest
            .get("")
            .baseUrl("")

        // Then
        XCTAssertEqual(request.type, NetworkRequestType.get)
        XCTAssertThrowsError(try request.url)
    }
}
