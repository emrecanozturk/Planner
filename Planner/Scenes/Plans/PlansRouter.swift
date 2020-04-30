//
//  PlansRouter.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

@objc protocol PlansRoutingLogic
{
  func routeToSomewhere(segue: UIStoryboardSegue?, sender: Any?)
}

protocol PlansDataPassing
{
  var dataStore: PlansDataStore? { get }
}

class PlansRouter: NSObject, PlansRoutingLogic, PlansDataPassing
{
  weak var viewController: PlansViewController?
  var dataStore: PlansDataStore?
  
  // MARK: Routing
  
  func routeToSomewhere(segue: UIStoryboardSegue?, sender: Any?)
  {
    if let segue = segue, let data = sender as? Plans.FetchPlans.ViewModel.DisplayedItem {
      let navController = segue.destination as! UINavigationController
      let detailController = navController.viewControllers.first as! DetailViewController
      dataStore?.plan = data
      detailController.id = dataStore!.plan!.id
      
//      passDataToSomewhere(source: dataStore!, destination: &detailController)
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: PlansViewController, destination: UIViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: PlansDataStore, destination: inout DetailViewController)
  {
//    destination.plan?.id = source.plan!.id
//    destination.plan?.title = source.plan!.title
//    destination.plan?.priority = source.plan!.priority
//    destination.plan?.date = source.plan!.date
//    destination.plan?.isDone = source.plan!.isDone
  }
  
}
