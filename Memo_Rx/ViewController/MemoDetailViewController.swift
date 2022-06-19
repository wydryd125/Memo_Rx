//
//  MemoDetailViewController.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
  
  func bindViewModel() {
      viewModel.title
          .drive(navigationItem.rx.title)
          .disposed(by: rx.disposeBag)
      
      viewModel.contents
          .bind(to: contentTableView.rx.items) { tableView, row, value in
              switch row {
              case 0:
                  let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                  cell.textLabel?.text = value
                 return cell
              case 1:
                  let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                cell.textLabel?.text = value
                  return cell
              default:
                  fatalError()
              }
          }
          .disposed(by: rx.disposeBag)
      
      // 메모 수정 기능
      editButton.rx.action = viewModel.makeEditAction()
      
      // 메모 공유 기능
      shareButton.rx.tap
          .throttle(.microseconds(500), scheduler: MainScheduler.instance)
          .withUnretained(self)
          .subscribe(onNext: { (vc, _ ) in
              let memo = vc.viewModel.memo.content
              let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
              vc.present(activityVC, animated: true, completion: nil)
          })
          .disposed(by: rx.disposeBag)
      
      deleteButton.rx.action = viewModel.makeDeleteAction()
      
//      var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//      viewModel.title
//          .drive(backButton.rx.title)
//          .disposed(by: rx.disposeBag)
//      
//      backButton.rx.action = viewModel.popAction
////      navigationItem.backBarButtonItem = backButton
//      navigationItem.hidesBackButton = true
//      navigationItem.leftBarButtonItem = backButton
  
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
