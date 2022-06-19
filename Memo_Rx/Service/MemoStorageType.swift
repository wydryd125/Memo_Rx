//
//  MemoStorageType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift

protocol MemoStorageType {
  //@discardableResult - 반환하는 값을 사용하지 않으면 이슈가 생기는데 그 이슈를 막아주는 역할
  @discardableResult
  func createMemo(content: String) -> Observable<Memo>
  
  @discardableResult
  func memoList() -> Observable<[MemoSelectionModel]>
  
  @discardableResult
  func update(memo: Memo, content: String) -> Observable<Memo>
  
  @discardableResult
  func delete(memo: Memo) -> Observable<Memo>
}

