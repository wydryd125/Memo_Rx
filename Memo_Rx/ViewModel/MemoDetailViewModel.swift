//
//  MemoDetailViewModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewMoel {
    let memo: Memo
    
    private var formmatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        
        return f
    }()
    
    var contents: BehaviorSubject<[String]>

    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatortype, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formmatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map { _ in }
    }
}
