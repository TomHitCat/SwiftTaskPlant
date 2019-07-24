//
//  SWWorker.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/23.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWWorker<T>: SWWorkarable {
    
    typealias Product = T
    
    private unowned var task: SWTask<T>
    
    private var supervisor: SWSuperviser<T>
    
    init(_ supervisor: SWSuperviser<T> , _ task: SWTask<T>) {
        self.task = task
        self.supervisor = supervisor
    }
    
    func doTask(_ task: SWTask<T>) {
        if task.onExecute() {
            task.task(self)
        }
    }
    
    func submit(_ event: SWEvent<T>) {
        switch event {
        case .produce(let product):
            if task.onProduce(product) { supervisor.feedback(task, event) }
        case .progress(let progress):
            if task.onProgress(progress) { supervisor.feedback(task, event) }
        case .complete:
            if task.onComplete() { supervisor.feedback(task, event) }
        case .error(let err):
            if self.task.onError(err) { supervisor.feedback(task, event) }
        }
    }
}
