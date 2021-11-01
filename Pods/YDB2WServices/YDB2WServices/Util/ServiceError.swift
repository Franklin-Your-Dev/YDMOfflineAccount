//
//  ServiceError.swift
//  YDUtilities
//
//  Created by Douglas Hennrich on 09/12/20.
//

import Foundation

public enum YDServiceError: Error {
  case noConnection
  case timeout
  case permanentRedirect      // Status code 308
  case badRequest             // Status code 400
  case unauthorized           // Status code 401
  case blockedUser            // Status code 403
  case notFound               // Status code 404
  case internalServerError    // Status code 500

  case cantCreateUrl
  case noService
  case unknow((message: String?, status: Int?))

  public var message: String {
    switch self {
      case .noConnection:
        return "Sem conexão"
        
      case .timeout:
        return "Timeout"
        
      case .permanentRedirect:
        return "API mudou de URL"

      case .badRequest:
        return "API inválida"

      case .unauthorized:
        return "Usuário não autorizado"

      case .blockedUser:
        return "Usuário bloqueado"

      case .notFound:
        return "API não encontrada"

      case .internalServerError:
        return "Erro na API"

      case .cantCreateUrl:
        return "Erro ao montar a API"

      case .noService:
        return "Sem serviço"

      case .unknow(let params):
        let (message, _) = params
        return message ?? "Erro inesperado"
    }
  }

  //
  public var type: YDServiceError {
    switch self {
      case .noConnection:
        return .noConnection
        
      case .timeout:
        return .timeout
        
      case .permanentRedirect:
        return .permanentRedirect

      case .badRequest:
        return .badRequest

      case .unauthorized:
        return .unauthorized

      case .blockedUser:
        return .blockedUser

      case .notFound:
        return .notFound

      case .internalServerError:
        return .internalServerError

      case .cantCreateUrl:
        return .cantCreateUrl

      case .noService:
        return .noService

      case .unknow(let tuple):
        return .unknow(tuple)
    }
  }

  public var statusCode: Int? {
    switch self {
      case .noConnection:
        return -1000
        
      case .timeout:
        return -1001
        
      case .permanentRedirect:
        return 308

      case .badRequest:
        return 400

      case .unauthorized:
        return 401

      case .blockedUser:
        return 403

      case .notFound:
        return 404

      case .internalServerError:
        return 500

      case .unknow(let params):
        let (_, status) = params
        return status

      default:
        return nil
    }
  }

  // MARK: Init
  public init(withMessage message: String) {
    self = .unknow((message, nil))
  }

  public init(error: Error?, status: Int? = nil) {
    guard let errorMessage = error?.localizedDescription,
          let statusCode = status
    else {
      self = .unknow((nil, nil))
      return
    }

    switch statusCode {
      case -1000:
        self = .noConnection
        
      case -1001:
        self = .timeout
        
      case 308:
        self = .permanentRedirect

      case 400:
        self = .badRequest

      case 401:
        self = .unauthorized

      case 403:
        self = .blockedUser

      case 404:
        self = .notFound

      case 500:
        self = .internalServerError

      default:
        self = .unknow((errorMessage, statusCode))
    }
  }
  
  public init(status: Int?) {
    guard let statusCode = status else {
      self = .unknow((nil, nil))
      return
    }
    
    switch statusCode {
      case -1000:
        self = .noConnection
        
      case -1001:
        self = .timeout
        
      case 308:
        self = .permanentRedirect

      case 400:
        self = .badRequest

      case 401:
        self = .unauthorized

      case 403:
        self = .blockedUser

      case 404:
        self = .notFound

      case 500:
        self = .internalServerError

      default:
        self = .unknow((nil, statusCode))
    }
  }
}
