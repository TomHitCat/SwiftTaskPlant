//
//  SWSuperviser.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWSuperviser<T> {
    typealias ProductReportType = (T) -> Void
    typealias ErrorReportType = (Error) -> Void
    typealias CompleteReportType = () -> Void
    typealias ProgressReportType = (Double) -> Void
    
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
    
    fileprivate func feedback(_ event: SWEvent<T>) {
        switch event {
        case .produce(let product):
            performProductReport(product)
        case .error(let error):
            performErrorReport(error)
        case .complete:
            performCompleteReport()
        case .progress(let progress):
            performProgressReport(progress)
        }
    }
    
    fileprivate func performProductReport(_ product: T) {
        self.productReport?(product)
    }
    
    fileprivate func performErrorReport(_ error: Error) {
        self.errorReport?(error)
    }
    
    fileprivate func performCompleteReport() {
        self.completeReport?()
    }
    
    fileprivate func performProgressReport(_ progress: Double) {
        self.progressReport?(progress)
    }
    
    func fbProduct(_ report: @escaping (T) -> Void) -> Self {
        self.productReport = report
        return self
    }
    
    func fbError(_ report: @escaping (Error) -> Void) -> Self {
        self.errorReport = report
        return self
    }
    
    func fbComplete(_ report: @escaping () -> Void) -> Self {
        self.completeReport = report
        return self
    }
    
    func fbProgress(_ report: @escaping (Double) -> Void) -> Self {
        self.progressReport = report
        return self
    }
    
    func distribute() -> Void {
        let worker: SWWorker<T> = SWWorker.init(self, self.task)
        self.perform(worker: worker, task: self.task)
    }
}
