import Foundation

//MARK: - Error

public enum NetworkError: Error {
    case requestError
    case unexpectedHTTPResponse
    case decodableError
    case wrongUrl
}

