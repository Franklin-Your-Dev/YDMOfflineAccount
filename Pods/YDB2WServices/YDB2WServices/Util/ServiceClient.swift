//
//  ServiceClient.swift
//  YDUtilities
//
//  Created by Douglas Hennrich on 09/12/20.
//

import Foundation
import Alamofire

// MARK: Protocol
protocol YDServiceClientDelegate: AnyObject {
  // default
  func request<T: Decodable>(
    withUrl: String,
    withMethod: HTTPMethod,
    andParameters: Parameters?,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  )

  // with headers
  func request<T: Decodable>(
    withUrl: String,
    withMethod: HTTPMethod,
    withHeaders: HTTPHeaders?,
    andParameters: Parameters?,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  )

  // with custom decoder
  func request<T: Decodable>(
    withUrl: String,
    withMethod: HTTPMethod,
    andParameters: Parameters?,
    customDecoder: JSONDecoder,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  )

  // with full response
  func requestWithFullResponse(
    withUrl: String,
    withMethod: HTTPMethod,
    withHeaders: HTTPHeaders?,
    andParameters: Parameters?,
    onCompletion completion: @escaping ((DataResponse<Data, YDServiceError>) -> Void)
  )

  // without caching request
  func requestWithoutCache<T: Decodable>(
    withUrl: String,
    withMethod: HTTPMethod,
    andParameters: Parameters?,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  )
}

// MARK: API
class YDServiceClient {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  let httpRequest: Session

  // MARK: Init
  init() {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10

    httpRequest = Session(configuration: config)
  }

  // MARK: Actions
  func buildUrl(
    url urlString: String,
    method: HTTPMethod,
    headers: HTTPHeaders? = nil,
    parameters: Parameters?
  ) throws -> URLRequestConvertible {

    let url = try urlString.asURL()

    var urlRequest = URLRequest(url: url)

    // Http method
    urlRequest.httpMethod = method.rawValue

    // Header
    if let headers = headers {
      headers.forEach {
        element in urlRequest.setValue(element.value, forHTTPHeaderField: element.name)
      }
    }

    //Encoding
    let encoding: ParameterEncoding = {
      switch method {
      case .get:
        return URLEncoding.default
      default:
        return JSONEncoding.default
      }
    }()

    return try encoding.encode(urlRequest, with: parameters)
  }
}

// MARK: Extend protocol
extension YDServiceClient: YDServiceClientDelegate {
  // MARK: Default
  func request<T: Decodable> (
    withUrl: String,
    withMethod: HTTPMethod = .get,
    andParameters: Parameters? = nil,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  ) {
    guard Connectivity.isConnectedToInternet() else {
      completion(.failure(.noConnection))
      return
    }
    
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(
            url: withUrl,
            method: withMethod,
            parameters: withParameters)
    else {
      return completion(.failure(.cantCreateUrl))
    }

    //
    httpRequest.request(urlRequestConvirtable)
      .validate()
      .responseJSON(emptyResponseCodes: [200, 201, 203, 204]) { [weak self] response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return completion(.failure(.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return completion(.success(result))
          } catch let errorCatch as NSError {
            self?.logger.error(errorCatch.debugDescription)
            return completion(
              .failure(
                .unknow(
                  (errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return completion(
            .failure(
              .init(
                error: error,
                status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: With Headers
  func request<T: Decodable> (
    withUrl: String,
    withMethod: HTTPMethod = .get,
    withHeaders: HTTPHeaders? = nil,
    andParameters: Parameters? = nil,
    onCompletion completion: @escaping ((Swift.Result<T, YDServiceError>) -> Void)
  ) {
    guard Connectivity.isConnectedToInternet() else {
      completion(.failure(.noConnection))
      return
    }
    
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(
            url: withUrl,
            method: withMethod,
            headers: withHeaders,
            parameters: withParameters)
    else {
      return completion(.failure(.cantCreateUrl))
    }

    //
    httpRequest.request(urlRequestConvirtable)
      .validate()
      .responseJSON(emptyResponseCodes: [200, 201, 203, 204]) { [weak self] response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return completion(.failure(.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return completion(.success(result))
          } catch let errorCatch as NSError {
            self?.logger.error(errorCatch.debugDescription)
            return completion(
              .failure(
                .unknow((errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return completion(
            .failure(
              .init(
                error: error,
                status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: With full response
  func requestWithFullResponse(
    withUrl: String,
    withMethod: HTTPMethod = .get,
    withHeaders: HTTPHeaders? = nil,
    andParameters: Parameters? = nil,
    onCompletion completion: @escaping ((DataResponse<Data, YDServiceError>) -> Void)
  ) {
    guard Connectivity.isConnectedToInternet() else {
      completion(
        DataResponse(
          request: nil,
          response: nil,
          data: nil,
          metrics: nil,
          serializationDuration: 0,
          result: .failure(.noConnection)
        )
      )
      return
    }
    
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(
            url: withUrl,
            method: withMethod,
            headers: withHeaders,
            parameters: withParameters)
    else {
      completion(
        DataResponse(
          request: nil,
          response: nil,
          data: nil,
          metrics: nil,
          serializationDuration: 0,
          result: .failure(.badRequest)
        )
      )
      return
    }

    //
    httpRequest.request(urlRequestConvirtable)
      .validate()
      .responseData(emptyResponseCodes: [200, 201, 203, 204]) { response in
        switch response.result {
          case .failure(let errorAF):
            let error = YDServiceError(status: errorAF.responseCode)
            
            completion(
              DataResponse(
                request: response.request,
                response: response.response,
                data: response.data,
                metrics: response.metrics,
                serializationDuration: response.serializationDuration,
                result: .failure(error)
              )
            )
            
          case .success(let data):
            completion(
              DataResponse(
                request: response.request,
                response: response.response,
                data: response.data,
                metrics: response.metrics,
                serializationDuration: response.serializationDuration, result: .success(data)
              )
            )
        }
      }
  }

  // MARK: With Custom Decoder
  func request<T: Decodable>(
    withUrl: String,
    withMethod: HTTPMethod,
    andParameters: Parameters?,
    customDecoder: JSONDecoder,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  ) {
    guard Connectivity.isConnectedToInternet() else {
      completion(.failure(.noConnection))
      return
    }
    
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(
            url: withUrl,
            method: withMethod,
            parameters: withParameters)
    else {
      return completion(.failure(YDServiceError.cantCreateUrl))
    }

    //
    httpRequest.request(urlRequestConvirtable)
      .validate()
      .responseJSON(emptyResponseCodes: [200, 201, 203, 204]) { [weak self] response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return completion(.failure(YDServiceError.badRequest))
          }

          do {
            let result = try customDecoder.decode(T.self, from: data)
            return completion(.success(result))
          } catch let errorCatch as NSError {
            self?.logger.error(errorCatch.debugDescription)
            return completion(
              .failure(
                YDServiceError.unknow(
                  (errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return completion(
            .failure(
              YDServiceError(
                error: error,
                status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: Without cache request
  func requestWithoutCache<T: Decodable> (
    withUrl: String,
    withMethod: HTTPMethod = .get,
    andParameters: Parameters? = nil,
    onCompletion completion: @escaping ((Result<T, YDServiceError>) -> Void)
  ) {
    guard Connectivity.isConnectedToInternet() else {
      completion(.failure(.noConnection))
      return
    }
    
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    //
    httpRequest.requestWithoutCache(
      withUrl,
      method: .get,
      parameters: withParameters,
      encoding: URLEncoding.default
    )
      .validate()
    .responseJSON(emptyResponseCodes: [200, 201, 203, 204]) { [weak self] response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return completion(.failure(YDServiceError.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return completion(.success(result))
          } catch let errorCatch as NSError {
            self?.logger.error(errorCatch.debugDescription)
            return completion(
              .failure(
                YDServiceError.unknow(
                  (errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return completion(
            .failure(
              YDServiceError(
                error: error,
                status: response.response?.statusCode
              )
            )
          )
        }
      }
  }
}

// MARK: Extend Alamofire Session Manager
extension Session {
  @discardableResult
  open func requestWithoutCache(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil) // also you can add URLRequest.CachePolicy here as parameter
  -> DataRequest
  {
    do {
      var urlRequest = try URLRequest(url: url, method: method, headers: headers)
      urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
      let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
      return request(encodedURLRequest)
    } catch {
      // TODO: find a better way to handle error
      print(error)
      return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
    }
  }
}
