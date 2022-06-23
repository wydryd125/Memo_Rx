//
//  ViewModelBindableType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import UIKit

/*
 MVVM 패턴으로 구현할 때는 view model읉 VC의 속성으로 추가, view model과 view를 binding
 */

protocol ViewModelBindableType {
    // ViewModelType은 vc마다 달라지기 때문에 제네릭 프로토콜로 선언해야 한다.
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    //binding에 필요한 메소드
    func bindViewModel()
}


 // VC에서 protocol을 채용하면 ViewModelType 메소드를 직접 호출하지 않기 때문에 코드가 단순해짐
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}

