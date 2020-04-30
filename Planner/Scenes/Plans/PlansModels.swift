//
//  PlansModels.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit
import RealmSwift

enum Plans
{
  // MARK: Use cases
  
  enum FetchPlans
  {
    struct Request
    {
        var id     : String
        var isDone : Bool
    }
    struct Response
    {
        var items: Results<Plan>?
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
        var displaedItems: [DisplayedItem]
    }
  }
}
