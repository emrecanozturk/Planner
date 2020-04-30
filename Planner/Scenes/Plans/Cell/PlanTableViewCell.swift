//
//  PlanTableViewCell.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright © 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

protocol CompletePlanProtocol: class {
  func setCompleted(_ isComplete: Bool, planID: String)
}

class PlanTableViewCell: UITableViewCell
{

  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var planTitleLabel: UILabel!
  @IBOutlet weak var planDateLabel: UILabel!
  
  weak var delegate: CompletePlanProtocol?
    
  var item: Plans.FetchPlans.ViewModel.DisplayedItem!
  {
      didSet{
          doneButton.isSelected = item.isDone
          switch item.priority {
          case 1:
              planTitleLabel.text = "!" + item.title
          case 2:
              planTitleLabel.text = "!!" + item.title
          default:
              planTitleLabel.text = item.title
          }
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        planDateLabel.text = dateFormatter.string(from: item.date)
      }
  }
    
  override func awakeFromNib()
  {
    super.awakeFromNib()
    doneButton.layer.cornerRadius = doneButton.frame.height / 2
    doneButton.layer.borderWidth = 2.0
    doneButton.layer.borderColor = UIColor.blue.cgColor
    doneButton.setBackgroundColor(.white, forState: .normal)
    doneButton.setBackgroundColor(.blue, forState: .selected)
  }
  
  @IBAction func selectDone(_ sender: UIButton)
  {
    sender.isSelected = !sender.isSelected
    delegate?.setCompleted(sender.isSelected, planID: item.id)
  }
    
}
