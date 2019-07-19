//
//  SWSuperviser.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWSuperviser<T>: SWSuperviserable {
    typealias Product = T
    
    private var productReport: ProductReportType?
    private var errorReport: ErrorReportType?
    private var progressReport: ProgressReportType?
    private var completeReport: CompleteReportType?
    private var task: SWTask<T>?
    private var worker: SWWorker<T>?
    
    init(task: SWTask<T>) {
        self.task = task
    }
    
    init(task: @escaping (SWWorker<T>) -> Void ) {
        self.task = SWTask.init(task: task)
    }
    
    func feedback(_ event: SWEvent<T>) {
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
    
    private func performProductReport(_ product: T) {
        self.productReport?(product)
    }
    
    private func performErrorReport(_ error: Error) {
        self.errorReport?(error)
    }
    
    private func performCompleteReport() {
        self.completeReport?()
    }
    
    private func performProgressReport(_ progress: Double) {
        self.progressReport?(progress)
    }
    
    func distribute() -> Void {
        guard let taskNONNIL = self.task else { return }
        self.perform(worker: SWWorker<T>.init(), task: taskNONNIL)
    }
}
