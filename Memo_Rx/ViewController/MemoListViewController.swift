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
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
