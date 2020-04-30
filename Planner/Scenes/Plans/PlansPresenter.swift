//
//  PlansPresenter.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

protocol PlansPresentationLogic
{
  func presentPlans(response: Plans.FetchPlans.Response)
}

class PlansPresenter: PlansPresentationLogic
{
  weak var viewController: PlansDisplayLogic?
  
  // MARK: Present Response
  
  func presentPlans(response: Plans.FetchPlans.Response)
  {
    if let items = response.items {
        let displayedItems = Array(items).map { (item) -> Plans.FetchPlans.ViewModel.DisplayedItem in
            let id = item.id
            let title = item.title
            let priority = item.priority
            let date = item.date
            let isDone = item.isDone
            return Plans.FetchPlans.ViewModel.DisplayedItem(id: id, title: title, priority: priority, date: date!, isDone: isDone)
        }
        let viewModel = Plans.FetchPlans.ViewModel(displaedItems: displayedItems)
        viewController?.presentPlans(viewModel: viewModel)

    }
  }
}
