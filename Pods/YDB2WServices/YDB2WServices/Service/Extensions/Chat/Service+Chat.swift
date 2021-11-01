//
//  Service+Chat.swift
//  YDB2WServices
//
//  Created by Douglas Hennrich on 05/05/21.
//

import Foundation
import Alamofire
import YDB2WModels

// Delegate
public protocol YDB2WServiceChatDelegate {
  func sendMessage(
    _ message: YDChatMessage,
    accessToken: String,
    onCompletion completion: @escaping (Result<String, YDServiceError>) -> Void
  )
  
  func sendReplyMessage(
    _ message: YDChatMessage,
    replyingToId: String,
    accessToken: String,
    onCompletion completion: @escaping (Result<String, YDServiceError>) -> Void
  )

  func getMessages(
    withChatId chatId: String,
    accessToken: String,
    limit: Int,
    lastMessageId: String?,
    onCompletion: @escaping (Result<YDChatMessagesList, YDServiceError>) -> Void
  )

  func sendLike(userId: String, onCompletion: @escaping (Swift.Result<Bool, YDServiceError>) -> Void)

  func deleteMessage(
    messageId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  )

  func getDeletedMessages(
    withChatId chatId: String,
    onCompletion: @escaping (Result<YDChatDeletedMessages, YDServiceError>) -> Void
  )

  func banUserFromChat(
    _ userId: String,
    ofLive liveId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  )

  func highlightMessage(
    ofId messageId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  )

  func removeHighlightMessage(
    ofId messageId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  )
  
  func sendHelp(
    toUser user: YDChatMessageSender,
    inResource resource: YDChatMessageResource,
    moderatorId: String,
    moderatorAccessToken accessToken: String,
    onCompletion completion: @escaping (Result<Void, YDServiceError>) -> Void
  )
}

public extension YDB2WService {
  func sendMessage(
    _ message: YDChatMessage,
    accessToken: String,
    onCompletion completion: @escaping (Result<String, YDServiceError>) -> Void
  ) {
    guard let json = try? message.asDictionary()
    else {
      completion(.failure(.badRequest))
      return
    }

    let headersDic: [String: String] = [
      "Access-Token": accessToken,
      "Content-Type": "application/json"
    ]
    let headers = HTTPHeaders(headersDic)

    let url = "\(chatService)/message"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .post,
        withHeaders: headers,
        andParameters: json
      ) { response in
        
        switch response.result {
          case .success:
            if let id = response.response?.allHeaderFields["Location"] as? String {
              completion(.success(id))
            } else {
              completion(.failure(.internalServerError))
            }

          case .failure(let error):
            guard let status = response.response?.statusCode,
                  status == 401,
                  let data = response.data,
                  let json = try? JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments
                  ) as? [String: Any],
                  let message = json["message"] as? String,
                  message == "banned user"
            else {
              completion(.failure(.init(error: error, status: response.response?.statusCode)))
              return
            }
            
            completion(.failure(.blockedUser))
        }
      }
    }
  }

  func getMessages(
    withChatId chatId: String,
    accessToken: String,
    limit: Int = 10,
    lastMessageId: String?,
    onCompletion: @escaping (Result<YDChatMessagesList, YDServiceError>) -> Void
  ) {
    let headersDic: [String: String] = [
      "Access-Token": accessToken
    ]
    let headers = HTTPHeaders(headersDic)

    var parameters: [String: Any] = [
      "limit": limit
    ]

    if let lastId = lastMessageId {
      parameters["lastMessage"] = lastId
    }

    let url = "\(chatService)/message/live/\(chatId)"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.request(
        withUrl: url,
        withMethod: .get,
        withHeaders: headers,
        andParameters: parameters
      ) { (result: Result<YDChatMessagesListInterface, YDServiceError>) in
        switch result {
          case .success(let interface):
            onCompletion(.success(interface.resource))

          case .failure(let error):
            onCompletion(.failure(error))
        }
      }
    }
  }

  func sendLike(
    userId: String,
    onCompletion: @escaping (Result<Bool, YDServiceError>) -> Void
  ) {
    let url = "\(chatService)/message/live/\(userId)"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.request(
        withUrl: url,
        withMethod: .post,
        andParameters: nil
      ) { (result: Result<Bool, YDServiceError>) in
        //
        switch result {
          case .success:
            onCompletion(.success(true))

          case .failure(let error):
            onCompletion(.failure(error))
        }
      }
    }
  }

  func deleteMessage(
    messageId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  ) {
    let url = "\(chatService)/message/\(messageId)"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .delete,
        withHeaders: nil,
        andParameters: nil
      ) { response in
        switch response.result {
          case .success:
            onCompletion(.success(()))

          case .failure(let error):
            onCompletion(.failure(.init(error: error)))
        }
      }
    }
  }

  func getDeletedMessages(
    withChatId chatId: String,
    onCompletion: @escaping (Result<YDChatDeletedMessages, YDServiceError>) -> Void
  ) {
    let parameters: [String: Any] = [
      "sortBy": "asc"
    ]

    let url = "\(chatService)/message/live/\(chatId)/deleted"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.request(
        withUrl: url,
        withMethod: .get,
        andParameters: parameters
      ) { (result: Result<YDChatDeletedMessages, YDServiceError>) in
        switch result {
          case .success(let interface):
            onCompletion(.success(interface))

          case .failure(let error):
            onCompletion(.failure(error))
        }
      }
    }
  }

  func banUserFromChat(
    _ userId: String,
    ofLive liveId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  ) {
    guard let resource = try? YDChatMessageResource(id: liveId).asDictionary()
    else {
      return
    }

    let url = "\(chatService)/customer/\(userId)/ban"

    let parameters: [String: Any] = [
      "resource": resource
    ]

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .post,
        withHeaders: nil,
        andParameters: parameters
      ) { response in
        switch response.result {
          case .success:
            onCompletion(.success(()))

          case .failure(let error):
            onCompletion(.failure(.init(error: error)))
        }
      }
    }
  }

  func highlightMessage(
    ofId messageId: String,
    onCompletion: @escaping(Result<Void, YDServiceError>) -> Void
  ) {
    let url = "\(chatService)/message/\(messageId)/fixed"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .post,
        withHeaders: nil,
        andParameters: nil
      ) { response in

        //
        switch response.result {
          case .success:
            onCompletion(.success(()))

          case .failure(let error):
            onCompletion(.failure(.init(error: error)))
        }
      }
    }
  }

  func removeHighlightMessage(
    ofId messageId: String,
    onCompletion: @escaping(Swift.Result<Void, YDServiceError>) -> Void
  ) {
    let url = "\(chatService)/message/\(messageId)/fixed"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .delete,
        withHeaders: nil,
        andParameters: nil
      ) { response in
        
        switch response.result {
          case .success:
            onCompletion(.success(()))

          case .failure(let error):
            onCompletion(.failure(.init(error: error)))
        }
      }
    }
  }
  
  func sendReplyMessage(
    _ message: YDChatMessage,
    replyingToId: String,
    accessToken: String,
    onCompletion completion: @escaping (Swift.Result<String, YDServiceError>) -> Void
  ) {
    message.repliedMessageId = replyingToId
    
    guard let json = try? message.asDictionary()
    else {
      completion(.failure(.badRequest))
      return
    }

    let headersDic: [String: String] = [
      "Access-Token": accessToken,
      "Content-Type": "application/json"
    ]
    let headers = HTTPHeaders(headersDic)

    let url = "\(chatService)/message?async=false"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .post,
        withHeaders: headers,
        andParameters: json
      ) { response in
        
        switch response.result {
          case .success:
            if let id = response.response?.allHeaderFields["Location"] as? String {
              completion(.success(id))
            } else {
              completion(.failure(.internalServerError))
            }

          case .failure(let error):
            guard let status = response.response?.statusCode,
                  status == 401,
                  let data = response.data,
                  let json = try? JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments
                  ) as? [String: Any],
                  let message = json["message"] as? String,
                  message == "banned user"
            else {
              completion(.failure(.init(error: error, status: response.response?.statusCode)))
              return
            }
            
            completion(.failure(.blockedUser))
        }
      }
    }
  }
  
  func sendHelp(
    toUser user: YDChatMessageSender,
    inResource resource: YDChatMessageResource,
    moderatorId: String,
    moderatorAccessToken accessToken: String,
    onCompletion completion: @escaping (Result<Void, YDServiceError>) -> Void
  ) {
    guard let json = try? resource.asDictionary()
    else {
      completion(.failure(.badRequest))
      return
    }

    let headersDic: [String: String] = [
      "Access-Token": accessToken,
      "Content-Type": "application/json"
    ]
    let headers = HTTPHeaders(headersDic)
    
    let parameters: [String: Any] = [
      "resource": json
    ]

    let url = "\(chatService)/customer/\(user.id)/help?adminCustomerId=\(moderatorId)"

    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.service.requestWithFullResponse(
        withUrl: url,
        withMethod: .post,
        withHeaders: headers,
        andParameters: parameters
      ) { response in
        switch response.result {
          case .success:
            completion(.success(()))

          case .failure(let error):
            completion(.failure(.init(error: error, status: response.response?.statusCode)))
        }
      }
    }
  }
}
