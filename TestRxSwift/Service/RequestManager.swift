//
//  RequestManager.swift
//  TestRxSwift
//
//  Created by Admin on 14/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

enum Errors: Int {
  case OK = 200
  case CREATED = 201
  case NOT_MODIFIED = 304
  case BAD_REQUEST = 400
  case INVALID_CREDENTIAL = 401
  case NOT_FOUND = 404
  case CONFLICT = 409
  case AUTHENTICATION_EXPIRED = 419   
  case BAD_MODEL_SERIALIZATION
}

enum Response<T> {
  case success(T)
  case error(Errors)
}

struct JSONRequest<T: Codable> {
  let urlString: String
  let method: HTTPMethod
  let parameters: [String: Any]
}

class RequestManager: NSObject {
  private let baseUrl: String = "https://cat-fact.herokuapp.com"
  private let decoder = JSONDecoder()
  
  static func jsonRequest<T>(urlString: String, method: HTTPMethod = .get, parameters: [String: Any] = [:]) -> JSONRequest<T> {
    return JSONRequest(urlString: urlString, method: method, parameters: parameters)
  }
  
  func request<T: Codable>(model: JSONRequest<T>)->Single<T>  {
    return Single<T>.create { (single) -> Disposable in
      if let url = URL(string: model.urlString, relativeTo: URL(string: self.baseUrl)) {
        AF.request(url).responseJSON { (response) in
          switch response.result {
          case .success(let data):
            if let newData = try? JSONSerialization.data(withJSONObject: data, options: []), let models = try? self.decoder.decode(T.self, from: newData) {
              single(.success(models))
            }
          case .failure(let error):
            single(.error(error))
            break
          }
        }
      }
      return Disposables.create {
        AF.cancelAllRequests()
      }
    }
  }
}
