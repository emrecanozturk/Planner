//
//  PlansViewController.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//
import UIKit

protocol PlansDisplayLogic: class
{
  func presentPlans(viewModel: Plans.FetchPlans.ViewModel)
}

class PlansViewController: UITableViewController, PlansDisplayLogic, CompletePlanProtocol
{
  
  var interactor: PlansBusinessLogic?
  var router: (NSObjectProtocol & PlansRoutingLogic & PlansDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = PlansInteractor()
    let presenter = PlansPresenter()
    let router = PlansRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
      if let router = router {
        
        router.routeToSomewhere(segue: segue, sender: sender)
      }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    registerTableViewCells()
    fetchItems()
  }
  
  // MARK: Table view
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return displayedObjects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    return configurePlanCell(forRowAt: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let request = Plans.FetchPlans.Request(id: displayedObjects[indexPath.row].id, isDone: Bool())
      interactor?.removePlan(request: request)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showDetailSegue", sender: displayedObjects[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func registerTableViewCells() {
    let itemCellNib = UINib(nibName: "PlanTableViewCell", bundle: nil)
    tableView.register(itemCellNib, forCellReuseIdentifier: "PlanTableViewCell")
  }
  
  private func configurePlanCell(forRowAt indexPath: IndexPath) -> PlanTableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell", for: indexPath) as! PlanTableViewCell
    cell.item = displayedObjects[indexPath.row]
    cell.delegate = self
    return cell
  }
  
  func setCompleted(_ isComplete: Bool, planID: String) {
    let request = Plans.FetchPlans.Request(id: planID, isDone: isComplete)
    interactor?.completePlan(request: request)
  }
  
  // MARK: Fetch Items
  
  @IBAction func moveAddPlan(_ sender: UIButton) {
    performSegue(withIdentifier: "showNewPlanAddSegue", sender: nil)
  }
  
  var displayedObjects = [Plans.FetchPlans.ViewModel.DisplayedItem]()
  
  func fetchItems()
  {
    let request = Plans.FetchPlans.Request(id: String(), isDone: Bool())
    interactor?.getAll(request: request)
  }
  
  func presentPlans(viewModel: Plans.FetchPlans.ViewModel)
  {
    displayedObjects = viewModel.displaedItems
    tableView.reloadData()
  }
  
}
