//
//  CommonViewModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewMoel: NSObject {
  let title: Driver<String>
  
  let sceneCoordinator: SceneCoordinatortype
  let storage: MemoStorageType
  
  init(title: String, sceneCoordinator: SceneCoordinatortype, storage: MemoStorageType) {
    self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
    self.sceneCoordinator = sceneCoordinator
    self.storage = storage
  }
}

