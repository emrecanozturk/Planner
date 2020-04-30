//
//  DetailWorker.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

class DetailWorker
{
  func checkPlanDatas(title: String?, priority: Int?) -> Bool
  {
    if let title = title, title == "Write a title for your plan" {
      return true
    }
    if title == nil || priority == nil { return true }
    return false
  }
}
