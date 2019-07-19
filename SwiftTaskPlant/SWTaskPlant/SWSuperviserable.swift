//
//  SWSuperviserable.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

protocol SWSuperviserable: class {
    associatedtype Product
    typealias ProductReportType = (Product) -> Void
    typealias ErrorReportType = (Error) -> Void
    typealias CompleteReportType = () -> Void
    typealias ProgressReportType = (Double) -> Void

    func feedback(_ event: SWEvent<Product>)
    
    func fbProduct(_ report: @escaping ProductReportType) -> Self
    
    func fbError(_ report: @escaping ErrorReportType) -> Self
    
    func fbComplete(_ report: @escaping CompleteReportType) -> Self
    
    func fbProgress(_ report: @escaping ProgressReportType) -> Self
}

