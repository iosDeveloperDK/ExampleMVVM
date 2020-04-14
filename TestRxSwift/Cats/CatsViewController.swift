//
//  CatsViewController.swift
//  TestRxSwift
//
//  Created by Admin on 14/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CatsViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchBar: UISearchBar!
  
  private let disposeBag = DisposeBag()
  private let refreshControl = UIRefreshControl()
  private let viewModel = CatsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurationUI()
    startObservers()
  }
  
  private func configurationUI() {
    self.tableView.addSubview(refreshControl)
    self.tableView.register(UINib(nibName: String(describing: CatsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CatsTableViewCell.self))
    self.tableView.rowHeight = UITableView.automaticDimension
  }
  
  private func startObservers() {
    viewModel.fetchData()
    searchBar.rx.text
      .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { (search) in
        self.viewModel.search = search
      }).disposed(by: disposeBag)
    refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.reload).disposed(by: disposeBag)
    viewModel.tableData
      .do(onNext: {[weak self] _ in self?.refreshControl.endRefreshing()})
      .bind(to: tableView.rx.items(cellIdentifier: String(describing: CatsTableViewCell.self))){ (index, data, cell) in
        if let cell = cell as? CatsTableViewCell {
          cell.configuration(model: data)
        }
    }.disposed(by: disposeBag)
  }
}
