//
//  SceneCoordinator.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatortype {
  private let bag = DisposeBag()
  private var window: UIWindow
  private var currentVC: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    currentVC = window.rootViewController!
  }
  
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
    let subject = PublishSubject<Never>() // 성공과 실패만 방출
    
    let target = scene.instantiat()
    
    switch style {
    case .root:
      currentVC = target
      window.rootViewController = target
      
      subject.onCompleted()
    
    case .push:
      guard let nav = currentVC.navigationController else {
        subject.onError(TransitionError.navigationControllerMissing)
        break
      }
      
      nav.pushViewController(target, animated: animated)
      currentVC = target
      
      subject.onCompleted()
      
    case .modal:
      currentVC.present(target, animated: animated) {
        subject.onCompleted()
      }
      currentVC = target
      
    }
    return subject.asCompletable()
    
  }
  
  @discardableResult
  func close(animated: Bool) -> Completable {
    return Completable.create { [unowned self] completable in
      if let presentingVC = self.currentVC.presentingViewController {
        self.currentVC.dismiss(animated: animated) {
          self.currentVC = presentingVC
          completable(.completed)
        }
      } else if let nav = self.currentVC.navigationController {
        guard nav.popViewController(animated: animated) != nil else {
          completable(.error(TransitionError.cannotPop))
          return Disposables.create()
        }
        
        self.currentVC = nav.viewControllers.last!
        completable(.completed)
     
      } else {
        completable(.error(TransitionError.unknown))
      }
      
      return Disposables.create()
   
    }
  }
}
