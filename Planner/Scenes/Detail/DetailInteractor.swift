//
//  DetailInteractor.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit
import RealmSwift

protocol DetailBusinessLogic
{
  func savePlan(request: Detail.FetchPlan.Request)
  func controlPlan(title: String?, priority: Int?)
  func getPlan(id: String)
  func updatePlan(request: Detail.FetchPlan.Request)
  func removePlan(request: Plans.FetchPlans.Request)
}

protocol DetailDataStore
{
  var plan: Detail.FetchPlan.ViewModel.DisplayedItem? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore
{
  var presenter: DetailPresentationLogic?
  var worker: DetailWorker?
  var plan: Detail.FetchPlan.ViewModel.DisplayedItem?
  
  var item: Plan!
  
  // MARK: Work With Plans
  
  func savePlan(request: Detail.FetchPlan.Request)
  {
    if plan == nil {
      item = Plan()
      item.id = request.id
      item.title = request.title
      item.priority = request.priority
      item.date = request.date
      item.isDone = request.isDone
      if let item = item {
        RealmWorker.shared.addPlan(plan: item)
      }
    }
    presenter?.succes()
  }
  
  func controlPlan(title: String?, priority: Int?) {
    worker = DetailWorker()
    let isEmpty = worker?.checkPlanDatas(title: title, priority: priority)
    
    if let isEmpty = isEmpty {
      presenter?.show(error: isEmpty)
    }
  }
  
  func getPlan(id: String)
  {
    let plan = RealmWorker.shared.getOne(id: id)
    let response = Detail.FetchPlan.Response(id: plan!.id,
                                             title: plan!.title,
                                             priority: plan!.priority,
                                             date: plan!.date!,
                                             isDone: plan!.isDone)
    presenter?.presentDatas(response: response)
  }
  
  func updatePlan(request: Detail.FetchPlan.Request)
  {
    let plan = Plan()
    plan.id = request.id
    plan.title = request.title
    plan.priority = request.priority
    plan.isDone = request.isDone

    RealmWorker.shared.updatePlan(plan: plan)
    
    presenter?.succes()
  }
  
  func removePlan(request: Plans.FetchPlans.Request)
  {
    RealmWorker.shared.deletePlan(id: request.id)
    presenter?.succes()
    
  }
  
}
