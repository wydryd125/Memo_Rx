//
//  SceneCoordinatorType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation
import RxSwift

/*
 MVVM-C
 SceneCoordinator가 공통적으로 사용해야 하는 함수를 구현
 */

protocol SceneCoordinatortype {
    // 새로운 scene을 어떤 타입으로 전환할 건지에 대한 함수
    // Completable을 return하기 때문에 전환 후 원하는 작업을 구현할 수 있다.
    // 구현하지 않을 수도 있기 대문에 @discardableResult 
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
  
    // 이전 scene으로 돌아가는 함수
  @discardableResult
  func close(animated: Bool) -> Completable
}
