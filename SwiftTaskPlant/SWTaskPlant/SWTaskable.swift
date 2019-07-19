//
//  SWTask.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

protocol SWTaskable: class {
    associatedtype Product
    typealias SWTasket = (SWWorker<Product>) -> Void
    init(task: @escaping SWTasket)
    var product: Product? { get }
    var schedule: Double { get }
    func onSchedule(_ schedule: Double)
    func onResult(_ result: Product)
}
