//
//  MemoryStorage.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
  private var list = [
    Memo(content: "Hello, RxSwift", insertData: Date().addingTimeInterval(-10)),
    Memo(content: "Lorem, Ipsum", insertData: Date().addingTimeInterval(-20))
  ]
  
  private lazy var store = BehaviorSubject<[Memo]>(value: list)
  
  @discardableResult
  func createMemo(content: String) -> Observable<Memo> {
    let memo = Memo(content: content)
    list.insert(memo, at: 0)
    
    store.onNext(list)
    
    return Observable.just(memo)
  }
  
  @discardableResult
  func memoList() -> Observable<[Memo]> {
    return store
  }
  
  @discardableResult
  func update(memo: Memo, content: String) -> Observable<Memo> {
    let updated = Memo(original: memo, updateContent: content)
    
    if let index = list.firstIndex(where: { $0 == memo }) {
      list.remove(at: index)
      list.insert(updated, at: index)
    }
    
    store.onNext(list)
    
    return Observable.just(updated)
  }
  
  @discardableResult
  func delete(memo: Memo) -> Observable<Memo> {
    if let index = list.firstIndex(where: { $0 == memo }) {
      list.remove(at: index)
    }
    
    store.onNext(list)
    
    return Observable.just(memo)
  }
  
  
}
