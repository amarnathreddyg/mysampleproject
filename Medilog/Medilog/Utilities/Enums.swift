//
//  Enums.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//


import Foundation
import Unbox

enum ResponseError: Error {
    case notFoundError
    case badRequestError
    case timeoutError
    case internalServerError
    case parseError
    case unboxParseError
    case unkonownError
    case errorWithMessage(String)
    
    func description() -> String {
        switch self {
        case .notFoundError:
            return "URL not found!!!"
        case .badRequestError:
            return "Bahrain.API.BadRequest"
        case .timeoutError:
            return "Bahrain.API.RequestTimeout"
        case .internalServerError:
            return "Bahrain.API.InternalServerError"
        case .parseError:
            return "Bahrain.API.ParseError"
        case .unboxParseError:
            return "Bahrain.API.UnboxParseError"
        case let .errorWithMessage(str):
            return str
        default:
            return "Bahrain.API.UnknownError"
        }
    }
}

enum ResponseStatusCode:Int {
    case success = 200
    case notFound = 404
    case badRequest = 400
    case timeout = 408
    case internalServer = 500
}

enum URI: String {
    case login = "/login/register"
    case verifyOTP = "/login/verify"
    case trips = "/trip"
    case child = "/child"
}

enum NetworkMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}


