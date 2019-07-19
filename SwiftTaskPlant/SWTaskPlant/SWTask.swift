//
//  SWTask.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTask<T>: SWTaskable {
    
    typealias Product = T
    
    fileprivate let task: SWTasket
    
    var product: T?

    var schedule: Double = 0
    
    required init(task: @escaping SWTasket) { self.task = task }
    
    func onSchedule(_ schedule: Double) { }
    
    func onResult(_ result: T) { }
}

extension SWSuperviser {
    func perform(worker: SWWorker<T>, task: SWTask<T>) {
        task.task(worker)
    }
}
