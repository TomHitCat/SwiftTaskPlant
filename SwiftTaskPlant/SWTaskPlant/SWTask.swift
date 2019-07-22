//
//  SWTask.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit


class SWTask<T> {
    
    typealias SWTasket = (SWWorker<Product>) -> Void
    
    typealias Product = T
    
    fileprivate let task: SWTasket
    
    private var product: [T] = []
    
    private var error: Error?

    private var schedule: Double = 0
    
    private var phase: AtomicInt32 = AtomicInt32.init(value: SWTaskPhase.SWTaskCreated.rawValue)
    
    fileprivate func onExecute() -> Bool {
        if SWTaskPhase.toExecution(self.phase) {
            return true
        }
        assert(false, "SWTask cannot invoke onExecute() when the task is executing or finished!")
        return false
    }
    
    required init(task: @escaping SWTasket) { self.task = task }
    
    fileprivate func onSchedule(_ schedule: Double) -> Bool {
        if SWTaskPhase.isExecuting(self.phase) {
            self.schedule = schedule
            return true
        }
        assert(false, "SWTask cannot invoke onSchedule(_:) when the task is not execute or finished!")
        return false
    }
    
    fileprivate func onResult(_ result: T) -> Bool {
        if SWTaskPhase.isExecuting(self.phase) {
            self.product.append(result)
            return true
        }
        assert(false, "SWTask cannot invoke onResult(_:) when the task is not execute or finished!")
        return false
    }
    
    fileprivate func onComplete() -> Bool {
        if SWTaskPhase.toComplete(self.phase) {
            return true
        }
        assert(false, "SWTask cannot invoke onResult(_:) when the task is not execute or finished!")
        return false
    }
    
    fileprivate func onError(_ error: Error) -> Bool {
        if SWTaskPhase.toError(phase) {
            self.error = error
            return true
        }
        assert(false, "SWTask cannot invoke onError(_:) when the task is not execute or finished!")
        return false
    }
}

extension SWSuperviser {
    func perform(worker: SWWorker<T>, task: SWTask<T>) {
        worker.doTask(task)
    }
}

class SWWorker<T>: SWWorkarable {
    
    typealias Product = T
    
    private unowned var task: SWTask<T>
    
    private var supervisor: SWSuperviser<T>
    
    init(_ supervisor: SWSuperviser<T> , _ task: SWTask<T>) {
        self.task = task
        self.supervisor = supervisor
    }
    
    fileprivate func doTask(_ task: SWTask<T>) {
        if task.onExecute() {
            task.task(self)
        }
    }
    
    func submit(_ event: SWEvent<T>) {
        switch event {
        case .complete:
            _ = self.task.onComplete()
        case .produce(let product):
            _ = self.task.onResult(product)
        case .error(let err):
            _ = self.task.onError(err)
        case .progress(let progress):
            _ = self.task.onSchedule(progress)
        }
    }
}

