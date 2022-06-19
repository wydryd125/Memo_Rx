//
//  Memo.swift
//  Memo_Rx
//
//  Created by Lee on 2022/06/10.
//

import Foundation
import RxDataSources

struct Memo: Equatable, IdentifiableType {
  var content: String
  var insertDate: Date
  var identity: String
  
  init(content: String, insertData: Date = Date()) {
    self.content = content
    self.insertDate = insertData
    self.identity = "\(insertData.timeIntervalSinceReferenceDate)"
  }
  
  init(original: Memo, updateContent: String) {
    self = original
    self.content = updateContent
  }
}
