//
//  UITextViewFixed.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright © 2020 Emrecan Ozturk. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView
{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup()
    {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }
}
