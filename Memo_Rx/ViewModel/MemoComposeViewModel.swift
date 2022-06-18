//
//  MemoComposeViewModel
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 쓰기 화면에서 사용하는 뷰모델 구현
class MemoComposeViewModel: CommonViewMoel {
    private let content: String?
    
    var initialText: Driver<String?> { //view에 binding
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    let saveAction: Action<String, Void> //저장
    let cancelAction: CocoaAction //취소
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatortype, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
