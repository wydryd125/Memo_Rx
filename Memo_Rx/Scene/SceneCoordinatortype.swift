//
//  SceneCoordinatorType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation
import RxSwift

protocol SceneCoordinatortype {
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
  
  @discardableResult
  func close(animated: Bool) -> Completable
}
