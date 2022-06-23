//
//  MemoStorageType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift

/*
 기본적인 CRUD의 함수 생성
 Observable로 return하기 때문에 원하는 방식으로 처리할 수 있다.
 memo data를 관리하는 class에서 사용
 */

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

