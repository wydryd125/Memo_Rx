//
//  Scene.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import UIKit

enum Scene {
  case list(MemoListViewModel)
  case detail(MemoDetailViewModel)
  case compose(MemoComposeViewModel)
}

extension Scene {
  func instantiat(from storyboard: String = "Main") -> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    
    switch self {
    case .list(let memoListViewModel):
      guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
        fatalError()
      }
      
      guard var listVC = nav.viewControllers.first as? MemoListViewController else {
        fatalError()
      }
      
      listVC.bind(viewModel: memoListViewModel)
      
      return nav
      
    case .detail(let memoDetailViewModel):
      guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
        fatalError()
      }
      
      detailVC.bind(viewModel: memoDetailViewModel)
      
      return detailVC
      
    case .compose(let memoComposeViewModel):
      guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeVC") as? UINavigationController else {
        fatalError()
      }
      
      guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
        fatalError()
      }
      
      composeVC.bind(viewModel: memoComposeViewModel)
      
      return nav
      
    }
  }
}
