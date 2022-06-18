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
        
        // 선택한 cell의 indexPath를 필요 -> rx.itemSelected
        // 선택한 cell의 데이터, 메모 필요 -> rx.modelselected
        // 메모를 선택하고 해제
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            // self에 대한 비소유 참조와 zip의 방출 요소가 하나의 tuple로 합쳐져서 방출
            //self -> vc, zip -> data
            .withUnretained(self)
            //next 이벤트가 전달되면 cell의 선택 상태를 해제
            .do(onNext: { (vc, data) in
                vc.listTableView.deselectRow(at: data.1, animated: true)
            })
            //위에서 선택 상태를 처리하였기 때문에 선택한 데이터만 방출
            .map { $1.0 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
