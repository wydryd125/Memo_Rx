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
        
        //saveAction을 Action으로 한번 더 랩핑하여 저장 saveAction이 nil이 아니어야지 저장 후 화면 닫음.
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        //parameter로 취소, 저장 구현 -> 처리 방식을 하나가 아닌 동적으로 구현하기 위해
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
