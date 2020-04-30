//
//  DetailModels.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

enum Detail
{
  // MARK: Use cases
  
  enum FetchPlan
  {
    struct Request
    {
        var id       : String
        var title    : String
        var priority : Int
        var date     : Date
        var isDone   : Bool
    }
    struct Response
    {
        var id       : String
        var title    : String
        var priority : Int
        var date     : Date
        var isDone   : Bool
    }
    struct ViewModel
    {
        struct DisplayedItem
        {
            var id       : String
            var title    : String
            var priority : Int
            var date     : Date
            var isDone   : Bool
        }
    }
  }
}
