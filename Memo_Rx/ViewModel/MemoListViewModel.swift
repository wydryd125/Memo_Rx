//
//  MemoListViewModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewMoel {
  var memoList: Observable<[Memo]> {
    return storage.memoList()
  }
}
