//
//  TransitionModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation

/*
 VC의 전환 방식의 스타일과 error형식 선언
 */

enum TransitionStyle {
  case root
  case push
  case modal
}
enum TransitionError: Error {
  case navigationControllerMissing //navi가 없을 때
  case cannotPop //navi stack에 추가되어 있는 vc를 pop 할 수 없을 때
  case unknown // error의 종류를 모를 때
}
