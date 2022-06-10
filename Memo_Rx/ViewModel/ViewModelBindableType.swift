//
//  ViewModelBindableType.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import UIKit

protocol ViewModelBindableType {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType! { get set }
  func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
  mutating func bind(viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    loadViewIfNeeded()
    
    bindViewModel()
  }
}

