//
//  DetailViewController.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright (c) 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

protocol DetailDisplayLogic: class
{
  func setDatas(model: Detail.FetchPlan.ViewModel.DisplayedItem)
  func exit()
  func show(error: Bool)
}

class DetailViewController: UIViewController, DetailDisplayLogic, UITextViewDelegate
{
  var interactor: DetailBusinessLogic?
  var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

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
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let router = DetailRouter()
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
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupUI()
    getPlan()
  }
  
  func setupUI()
  {
    titleTextView.isScrollEnabled = false
    textViewDidEndEditing(titleTextView)
    
    view.endEditing(true)
    
    for button in priorityButtons {
      button.layer.cornerRadius = button.frame.height / 2
    }
  }
  
  func getPlan()
  {
    if let id = id {
      interactor?.getPlan(id: id)
    } else {
      titleTextView.becomeFirstResponder()
    }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    view.endEditing(true)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
  {
      if(text == "\n") {
          textView.resignFirstResponder()
          return false
      }
      return true
  }
  
  func textViewDidChange(_ textView: UITextView)
  {
    let size = CGSize(width: textView.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    titleTextViewHeightConstraint.constant = estimatedSize.height
  }
  
  func textViewDidBeginEditing(_ textView: UITextView)
  {
    if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
      }
  }
  
  func textViewDidEndEditing(_ textView: UITextView)
  {
      if textView.text.isEmpty {
          textView.text = "Write a title for your plan"
          textView.textColor = UIColor.lightGray
      }
  }
  
  // MARK: Let's Get Up!
  
  var priority: Int?
  var id: String?
  var model: Detail.FetchPlan.ViewModel.DisplayedItem?
  
  @IBOutlet weak var titleTextView: UITextViewFixed!
  @IBOutlet weak var titleTextViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var priorityButtons: [UIButton]!
  @IBOutlet weak var dateTitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  
  
  @IBAction func setPriority(_ sender: UIButton)
  {
    for button in priorityButtons {
      button.layer.borderWidth = 0.0
    }
    sender.layer.borderWidth = 2.0
    sender.layer.borderColor = UIColor.blue.cgColor
    priority = sender.tag
  }
  
  @IBAction func deleteOnClick(_ sender: UIButton)
  {
    interactor?.removePlan(request: Plans.FetchPlans.Request(id: id!, isDone: Bool()))
  }
  
  @IBAction func savePlan(_ sender: UIBarButtonItem)
  {
    if let _ = id {
      updatePlan()
      return
    }
    interactor?.controlPlan(title: titleTextView.text, priority: priority)
  }
  
  @IBAction func cancelDetail(_ sender: UIBarButtonItem)
  {
    dismiss(animated: true, completion: nil)
  }
  
  func savePlan()
  {
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = Date()
    let interval = date.timeIntervalSince1970
    
    let request = Detail.FetchPlan.Request(id: String(interval), title: titleTextView.text, priority: priority!, date: date, isDone: false)
    interactor?.savePlan(request: request)
  }
  
  func updatePlan() {
    let request = Detail.FetchPlan.Request.init(id: model!.id, title: titleTextView.text, priority: priority!, date: Date(), isDone: model!.isDone)
    interactor?.updatePlan(request: request)
  }
  
  func exit()
  {
    dismiss(animated: true, completion: nil)
  }
  
  func show(error: Bool)
  {
    if error {
      showAlert(title: "Please", message: "Fill and select all fields", vc: self) { }
      return
    }
    savePlan()
  }
  
  func setDatas(model: Detail.FetchPlan.ViewModel.DisplayedItem) {
    self.model = model
    
    titleTextView.text = model.title
    titleTextView.textColor = .black

    dateLabel.isHidden = false
    dateTitleLabel.isHidden = false
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateLabel.text = dateFormatter.string(from: model.date)
    
    priority = model.priority
    
    for button in priorityButtons {
      button.layer.borderWidth = 0.0
      if button.tag == model.priority {
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.blue.cgColor
      }
    }
    deleteButton.isHidden = false
  }
  
}
