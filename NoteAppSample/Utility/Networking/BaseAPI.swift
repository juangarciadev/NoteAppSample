//
//  BaseAPI.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Alamofire

/// Network provider wrapper.
struct BaseAPI {
    
    // MARK: - Initializers
    // Use static functions.
    private init() {}
    
    // MARK: - Public Functions
    
    /// Creates a `DataRequest` from a `URLRequest` created using the passed components and a `RequestInterceptor`.
    ///
    /// - Parameters:
    ///   - convertible: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - encoding: `ParameterEncoding` to be used to encode the `parameters` value into the `URLRequest`.
    ///               `URLEncoding.default` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - completion: Call-back upon successful response.
    static func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        encoding: NetworkParameterEncoding = .urlEncodingDefault,
                        headers: HTTPHeaders? = nil,
                        completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding.AFParameterEncoding(),
                   headers: headers)
            .validate()
            .responseJSON { response in
                completion(response)
        }
    }
    
    static func uploadImage(data: Data,
                            url: URLConvertible,
                            usingThreshold encodingMemoryThreshold: UInt64 = UInt64(),
                            method: HTTPMethod = .post,
                            headers: HTTPHeaders? = [:],
                            _ completion: @escaping (AFDataResponse<Any>) -> Void) {
        
        _ = AF.upload(multipartFormData: { multipart in
            multipart.append(data,
                             withName: GlobalConfiguration.imageName,
                             fileName: GlobalConfiguration.imageFileName,
                             mimeType: GlobalConfiguration.imageMimeType)
        }, to: url,
           usingThreshold: encodingMemoryThreshold,
           method: method,
           headers: headers).responseJSON(completionHandler: { response in
            completion(response)
           })
    }
}

/// Network errors.
enum NetworkError: Error {
    case badURL
    case parsingFailed
    case noData
}

/// Network parameter encoding .
enum NetworkParameterEncoding {
    case urlEncodingDefault
    case jsonEncodingDefault
     
    func AFParameterEncoding() -> ParameterEncoding {
        switch self {
        case .urlEncodingDefault:
            return URLEncoding.default
        case .jsonEncodingDefault:
            return JSONEncoding.default
        }
    }
}
