//
//  PlansInteractor.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//
import UIKit

protocol PlansBusinessLogic
{
  func getAll(request: Plans.FetchPlans.Request)
  func completePlan(request: Plans.FetchPlans.Request)
  func removePlan(request: Plans.FetchPlans.Request)
}

protocol PlansDataStore
{
  var plan: Plans.FetchPlans.ViewModel.DisplayedItem? { get set }
}

class PlansInteractor: PlansBusinessLogic, PlansDataStore, RealmWorkerDelegate
{
  var plan: Plans.FetchPlans.ViewModel.DisplayedItem?
  var presenter: PlansPresentationLogic?
  var worker: PlansWorker?
  
  // MARK: Work With Plans
  
  func getAll(request: Plans.FetchPlans.Request)
  {
    RealmWorker.shared.addDelegate(delegate: self)
    let plans = RealmWorker.shared.getAll()
    let response = Plans.FetchPlans.Response(items: plans)
    presenter?.presentPlans(response: response)
  }
  
  func completePlan(request: Plans.FetchPlans.Request)
  {
    RealmWorker.shared.updateStatus(id: request.id, isDone: request.isDone)
    getAll(request: request)
  }
  
  func removePlan(request: Plans.FetchPlans.Request)
  {
    RealmWorker.shared.deletePlan(id: request.id)
    getAll(request: request)
  }
  
  func realmWorkerHasChanged() {
    let plans = RealmWorker.shared.getAll()
    let response = Plans.FetchPlans.Response(items: plans)
    presenter?.presentPlans(response: response)
  }
}
