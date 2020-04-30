//
//  Plan.swift
//  Planner
//
//  Created by Emrecan Ozturk on 30.04.2020.
//  Copyright © 2020 Emrecan Ozturk. All rights reserved.
//

import Foundation
import RealmSwift

final class Plan: Object
{
    @objc dynamic var id       : String = ""
    @objc dynamic var title    : String = ""
    @objc dynamic var priority : Int = 0
    @objc dynamic var date     : Date? = nil
    @objc dynamic var isDone   : Bool = false
}
