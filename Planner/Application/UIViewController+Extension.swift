//
//  UIViewController+Extension.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright © 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, vc: UIViewController, completionBlock:@escaping ()->()) {
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completionBlock()
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
