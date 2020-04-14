//
//  CatsViewModel.swift
//  TestRxSwift
//
//  Created by Admin on 14/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RxSwift

class CatsViewModel: NSObject {
  private let request = RequestManager()
  private let disposeBag = DisposeBag()
  private var models: [CatFactModel] = [] {
    didSet {
      self.tableData.onNext(models)
    }
  }
  
  var reload = PublishSubject<Void>().asObserver()
  var tableData = PublishSubject<[CatFactModel]>().asObserver()
  var search: String? = nil {
    didSet {
      self.tableData.onNext(self.models.filter { (model) -> Bool in
        if let search = search, search.count > 0 {
          return model.text?.contains(search) ?? true
        }
        return true
      })
    }
  }
  
  override init() {
    super.init()
    reload.subscribe { (_) in
      self.fetchData()
    }.disposed(by: disposeBag)
  }
  
  func fetchData() {
    request.request(model: CatFactModel.fetchFacts()).asObservable().bind { (model) in
      if let models = model.all {
        self.models = models
      }
    }.disposed(by: disposeBag)
  }
}
