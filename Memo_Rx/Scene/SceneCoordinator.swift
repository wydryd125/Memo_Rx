//
//  SceneCoordinator.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation
import RxSwift
import RxCocoa

/*
 화면 전환 처리
 */

extension UIViewController {
    //실제로 화면에 표시되어 있는 vc를 return
    var sceneViewController: UIViewController {
        return self.children.last ?? self
    }
}

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
        let subject = PublishSubject<Never>() // 화면 전환의 성공과 실패만 방출
        
        let target = scene.instantiat() // 실제로 scene을 만듦
        
        switch style {
        case .root:
            //sceneViewController가 return하는 vc를 currentVC에 저장
            currentVC = target.sceneViewController
            window.rootViewController = target
            
            subject.onCompleted()
            
        case .push:
            print(currentVC)
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, evt) in
                    coordinator.currentVC = evt.viewController.sceneViewController })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
            
        }
        
        //Completable를 return해야 하기 때문에 asCompletable 추가
        return subject.asCompletable()
        
    }
    
    // transition는 asCompletable를 사용하여 Completable로 변환
    // close는 Completable를 직접 구현
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!.sceneViewController
                completable(.completed)
                
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
            
        }
    }
}
