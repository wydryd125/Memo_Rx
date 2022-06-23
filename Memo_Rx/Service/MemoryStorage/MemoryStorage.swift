//
//  MemoryStorage.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift

/*
 배열에 메모를 저장하는 메모리 저장소
 */

class MemoryStorage: MemoStorageType {
    private var list = [
        Memo(content: "Hello, RxSwift", insertData: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem, Ipsum", insertData: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSelectionModel(model: 0, items: list)
    
    private lazy var store = BehaviorSubject<[MemoSelectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSelectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        //내부에 있는 베열을 변경한 다음 새로운 next 이벤트를 방출(=새로운 배열 방출). tableView가 update
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
//            sectionModel.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    
}
