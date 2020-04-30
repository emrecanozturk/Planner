//
//  RealmWorker.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright © 2020 Emrecan Ozturk. All rights reserved.
//

import Foundation
import RealmSwift


protocol RealmWorkerDelegate: class
{
  func realmWorkerHasChanged()
}

class RealmWorker
{
  var realm: Realm!
    
  var notificationToken: NotificationToken?
  private var delegates = [RealmWorkerDelegate]()
  
  static let shared = RealmWorker()
    
  private init() {}
  
  deinit
  {
    notificationToken?.invalidate()
  }
    
// MARK: Setup
      
  func setupRealm()
  {
    configure()
    observe()
  }
  
  func configure()
  {
    do {
      let config = Realm.Configuration(objectTypes: [Plan.self])
      realm = try Realm(configuration: config)
    } catch let error {
      print(error)
    }
  }
  
  func addDelegate(delegate: RealmWorkerDelegate)
  {
    if indexOfDelegate(delegate: delegate) == nil {
      delegates.append(delegate)
    }
  }
  
  private func indexOfDelegate(delegate: RealmWorkerDelegate) -> Int?
  {
    return delegates.firstIndex(where: { $0 === delegate })
  }
  
  private func observe()
  {
    notificationToken = realm.observe({ (notification, realm) in
      for delegate in self.delegates {
        delegate.realmWorkerHasChanged()
      }
    })
  }
  
  func getAll() -> Results<Plan>
  {
    let objects = realm.objects(Plan.self)
    return objects
  }
  
  func getOne(id: String) -> Plan?
  {
    let object = realm.objects(Plan.self).filter("id == %@", id).first
    return object
  }
  
  func addPlan(plan: Plan)
  {
    try! realm.write {
      realm.add(plan)
    }
  }
  
  func updateStatus(id: String, isDone: Bool)
  {
    let object = realm.objects(Plan.self).filter("id == %@", id).first
    try! realm.write {
      object?.isDone = isDone
    }
  }
  
  func updatePlan(plan: Plan)
  {
    let object = realm.objects(Plan.self).filter("id == %@", plan.id).first
    try! realm.write {
      object?.title = plan.title
      object?.priority = plan.priority
      object?.isDone = plan.isDone
    }
  }
  
  func deletePlan(id: String)
  {
    if let object = realm.objects(Plan.self).filter("id == %@", id).first {
      try! realm.write {
        realm.delete(object)
      }
    }
  }
  
}
