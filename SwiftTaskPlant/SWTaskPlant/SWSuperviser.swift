//
//  SWSuperviser.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWSuperviser<T> {
    typealias ProductReportType = (SWTask<T>, T) -> Void
    typealias ErrorReportType = (SWTask<T>, Error) -> Void
    typealias CompleteReportType = (SWTask<T>) -> Void
    typealias ProgressReportType = (SWTask<T>, Double) -> Void
    
    private var productReport: ProductReportType?
    private var errorReport: ErrorReportType?
    private var progressReport: ProgressReportType?
    private var completeReport: CompleteReportType?
    private let task: SWTask<T>
    
    init(task: SWTask<T>) {
        self.task = task
    }
    
    init(task: @escaping (SWWorker<T>) -> Void ) {
        self.task = SWTask.init(task: task)
    }
    
    func feedback(_ task: SWTask<T>, _ event: SWEvent<T>) {
        switch event {
        case .produce(let product):
            performProductReport(task, product)
        case .error(let error):
            performErrorReport(task, error)
        case .complete:
            performCompleteReport(task)
        case .progress(let progress):
            performProgressReport(task, progress)
        }
    }
    
    fileprivate func performProductReport(_ task: SWTask<T>, _ product: T) {
        self.productReport?(task, product)
    }
    
    fileprivate func performErrorReport(_ task: SWTask<T>, _ error: Error) {
        self.errorReport?(task, error)
    }
    
    fileprivate func performCompleteReport(_ task: SWTask<T>) {
        self.completeReport?(task)
    }
    
    fileprivate func performProgressReport(_ task: SWTask<T>, _ progress: Double) {
        self.progressReport?(task, progress)
    }
    
    func fbProduct(_ report: @escaping (_ task: SWTask<T>, T) -> Void) -> Self {
        self.productReport = report
        return self
    }
    
    func fbError(_ report: @escaping (_ task: SWTask<T>, Error) -> Void) -> Self {
        self.errorReport = report
        return self
    }
    
    func fbComplete(_ report: @escaping (_ task: SWTask<T>) -> Void) -> Self {
        self.completeReport = report
        return self
    }
    
    func fbProgress(_ report: @escaping (_ task: SWTask<T>, Double) -> Void) -> Self {
        self.progressReport = report
        return self
    }
    
    func distribute() -> Void {
        let worker: SWWorker<T> = SWWorker.init(self, self.task)
        self.perform(worker: worker, task: self.task)
    }
}
