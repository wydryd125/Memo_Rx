//
//  MemoListViewController.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
  @IBOutlet weak var listTableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  var viewModel: MemoListViewModel!
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.memoList
      .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
        cell.textLabel?.text = memo.content
      }
      .disposed(by: rx.disposeBag)
      
      addButton.rx.action = viewModel.makeCreateAction()
      
      Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
          .withUnretained(self)
          .do(onNext: { (vc, data) in
              vc.listTableView.deselectRow(at: data.1, animated: true)
          })
              .map { $1.0 }
              .bind(to: viewModel.detailAction.inputs)
              .disposed(by: rx.disposeBag)
      
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
