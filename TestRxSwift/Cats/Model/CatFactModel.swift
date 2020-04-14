//
//  CatModel.swift
//  TestRxSwift
//
//  Created by Admin on 14/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class FactModel: Codable {
  var all: [CatFactModel]?
}

class CatFactModel: Codable {
  var _id: String?
  var text: String?
}

extension CatFactModel {
  static func fetchFacts() -> JSONRequest<FactModel> {
    return RequestManager.jsonRequest(urlString: "/facts")
  }
}
