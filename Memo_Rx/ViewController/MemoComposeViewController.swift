//
//  MemoComposeViewController.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        //Action library를 사용하여 구현하면 action속성에 저장하는 방식으로 사용한다.
        //cancelButton을 눌렀을때 cancelAction에 랩핑되어 있는 코드가 실현된다.
        cancelButton.rx.action = viewModel.cancelAction
        
        //더블 탭이 되지 않게 throttle을 이용하여 탭 후 0.5초동안 입력을 받지 못하게 설정.
        //textview에 있는 text를 방출
        //위의 방출된 액션을 saveAction과 bind
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        
        // 키보드 노출시 키보드가 뷰를 텍스트 뷰를 가리는 문제 수정
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        //옵셔널을 자동으로 언래핑하기위해 compactMap 사용
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObserbable = Observable.merge(willShowObservable, willHideObservable)
            .share()
        
        keyboardObserbable
            .withUnretained(contentTextView)
            .subscribe(onNext: { tv, height in
                //텍스트 뷰 위치 수정
                var inset = tv.contentInset
                inset.bottom = height
                tv.contentInset = inset
                
                //텍스트 뷰 스크롤 가능 추가
                var scrollInset = tv.verticalScrollIndicatorInsets
                scrollInset.bottom = height
                tv.verticalScrollIndicatorInsets = scrollInset
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
