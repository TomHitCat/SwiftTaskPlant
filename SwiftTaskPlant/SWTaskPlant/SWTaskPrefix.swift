//
//  SWTaskPrefix.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/24.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTaskPrefix<T>: SWTask<T> {
    typealias SWTaskCondition = (T) -> Bool
    let prefixCondition: SWTaskCondition
    init(_ task: @escaping SWTasket, _ condition: @escaping SWTaskCondition) {
        prefixCondition = condition
        super.init(task: task)
    }
    
    required init(task: @escaping SWTasket) {
        prefixCondition = { (T) -> Bool in return true }
        super.init(task: task)
    }
    
}
