//
//  MockURLProtocol.swift
//  Recipe AppTests
//
//  Created by Dajun Xian on 2024/11/21.
//

import Foundation
import XCTest

/// A mock URLProtocol to intercept network requests and provide custom responses.
class MockURLProtocol: URLProtocol {
    
    /// Handler to intercept requests and return mock responses.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    /// Determines whether this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    /// Returns a canonical version of the request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Starts loading the request by invoking the request handler.
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable.")
            return
        }
        
        do {
            // Get the mock response and data from the handler.
            let (response, data) = try handler(request)
            
            // Send the mock response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            // Send the mock data to the client.
            client?.urlProtocol(self, didLoad: data)
            // Notify that loading has finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Notify the client of the failure.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    /// Stops loading the request. Required to conform to URLProtocol.
    override func stopLoading() {
        // No additional cleanup required.
    }
}
