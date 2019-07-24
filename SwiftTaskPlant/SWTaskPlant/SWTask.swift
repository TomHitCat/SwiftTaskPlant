//
//  SWTask.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit


class SWTask<T> {
    
    typealias SWTasket = (SWWorker<T>) -> Void
    
    typealias SWTaskFilteret = (T) -> Bool
    
    let task: SWTasket
    
    var progress: Double { return _progress }
    
    private var _progress: Double = 0
    
    private var lock: NSLock = NSLock()
    
    private var error: Error?

    private var schedule: Double = 0
    
    private var filter: SWTaskFilteret?
    
    private var phase: AtomicInt32 = AtomicInt32.init(value: SWTaskPhase.SWTaskCreated.rawValue)
    
    required init(task: @escaping SWTasket) { self.task = task }
    
    func onComplete() -> Bool {
        if SWTaskPhase.toComplete(self.phase) { return true }
        return false
    }
    
    func onError(_ error: Error) -> Bool {
        if SWTaskPhase.toError(self.phase) { self.error = error; return true }
        return false
    }
    
    func onProduce(_ product: T) -> Bool { return false }
    
    func onProgress(_ progress: Double) -> Bool { _progress = progress; return false }
    
    final func isExecuting() -> Bool { return SWTaskPhase.isExecuting(self.phase) }
    
    final func isComplete() -> Bool { return SWTaskPhase.isFinish(self.phase) }
    
    final func isFinish() -> Bool { return SWTaskPhase.isFinish(self.phase) }
    
    final func filter(_ f: @escaping SWTaskFilteret) -> Self { self.filter = f; return self }
    
    final func canFillFilter(_ product: T) -> Bool {
        return self.filter?(product) ?? true
    }
    
    final func onExecute() -> Bool {
        if SWTaskPhase.toExecution(self.phase) { return true }
        return false
    }
    
    final func synchronized<S>(block: () -> S?) -> S? {
        var result: S?
        lock.lock()
        result = block()
        lock.unlock()
        return result
    }
    
    
    
}

extension SWSuperviser {
    
    func perform(worker: SWWorker<T>, task: SWTask<T>) {
        worker.doTask(task)
    }
    
}


