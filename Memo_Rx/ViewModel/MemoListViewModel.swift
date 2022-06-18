//
//  MemoListViewModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel: CommonViewMoel {
  var memoList: Observable<[Memo]> {
    return storage.memoList()
  }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        //createButton을 눌렀을 때 바로 메모에 ""로 추가된다. 그래서 추가가 아닌 update 함수를 써야한다.
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            //createButton을 눌렀을 때 바로 메모에 ""로 추가된다. 그래서 삭제를 해야 추가된 메모가 사라진다.
            return self.storage.delete(memo: memo).map { _ in}
        }
    }
    
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
        }
    }()

}
