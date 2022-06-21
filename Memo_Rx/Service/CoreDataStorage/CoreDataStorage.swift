//
//  CoreDataStorage.swift
//  Memo_Rx
//
//  Created by Yukyung Jeong on 2022/06/21.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

//memoryStorage를 CoreDataStorage로 체인지
//memoryStorage 채용하여 사용하고 SceneDelegate에서 CoreDataStorage로 의존성 수정함.
class CoreDataStorage: MemoStorageType {
    let modelName: String
    
    init(modelName:String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        
        do {
           _ = try mainContext.rx.update(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
            
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSelectionModel]> {
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { results in [MemoSelectionModel(model: 0, items: results)] }
        
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
        do {
            _ = try mainContext.rx.update(updated)
         
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        do {
            try mainContext.rx.delete(memo)
            
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
    
    
}
