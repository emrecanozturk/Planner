//
//  DetailPresenter.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic
{
  func presentDatas(response: Detail.FetchPlan.Response)
  func succes()
  func show(error: Bool)
}

class DetailPresenter: DetailPresentationLogic
{
  weak var viewController: DetailDisplayLogic?
  
  // MARK: Present
  
  func presentDatas(response: Detail.FetchPlan.Response)
  {
    let viewModel = Detail.FetchPlan.ViewModel.DisplayedItem(id: response.id,
                                                             title: response.title,
                                                             priority: response.priority,
                                                             date: response.date,
                                                             isDone: response.isDone)
    
    viewController?.setDatas(model: viewModel)
  }
  
  func succes()
  {
    viewController?.exit()
  }
  
  func show(error: Bool)
  {
    viewController?.show(error: error)
  }
}
