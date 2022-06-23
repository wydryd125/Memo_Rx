//
//  Scene.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import UIKit

/*
 Momo_Rx 구현해야하는 Scene
 */

enum Scene {
    case list(MemoListViewModel) // 메모 목록, 연관된 view model 저장
    case detail(MemoDetailViewModel) // 메모 자세히
    case compose(MemoComposeViewModel) // 메모 쓰기
}

/*
 SB에 있는 scene을 생성하고 연관 값에 있는 view model를 binding해서 return
 */

extension Scene {
    func instantiat(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            //listVC는 navigation에 embed 되어 있기 떄문에 nav부터 만들고 접근.
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async { //바인딩 시간을 늦춰야 네비게이션 타이틀 사이즈가 라지로 나옴
                listVC.bind(viewModel: memoListViewModel)
            }
            
            return nav
            
        case .detail(let memoDetailViewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                detailVC.bind(viewModel: memoDetailViewModel)
            }
            
            return detailVC
            
        case .compose(let memoComposeViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                composeVC.bind(viewModel: memoComposeViewModel)
            }
            
            return nav
            
        }
    }
}
