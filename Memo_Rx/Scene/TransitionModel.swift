//
//  TransitionModel.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/13.
//

import Foundation

enum TransitionStyle {
  case root
  case push
  case modal
}
enum TransitionError: Error {
  case navigationControllerMissing
  case cannotPop
  case unknown
}
