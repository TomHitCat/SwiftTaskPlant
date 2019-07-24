//
//  SWTaskRange.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/24.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTaskRange<T>: SWTask<T> {
    
    private var from: Int
    
    private var to: Int
    
    private var currentIndex: Int = 0
    
    private var _products: [T] = []
    
    var count: Int { return _products.count }
    
    var products: [T] { return _products }
    
    init(_ from: Int, _ to: Int, task: @escaping SWTasket) {
        self.from = from
        self.to = to
        super.init(task: task)
    }
    
    required init(task: @escaping SWTasket) {
        self.from = 0
        self.to = Int.max
        super.init(task: task)
    }
    
    override func onProduce(_ product: T) -> Bool {
        if self.isFinish() || !canFillFilter(product) { return false }
        if currentIndex >= from && currentIndex < to {
            _products.append(product)
            return true
        }
        currentIndex += 1
        return false
    }
    
}


class SWTaskRangeSafe<T>: SWTaskRange<T> {
    
    override var count: Int { return self.synchronized { return super.count }! }
    
    override var products: [T] { return self.synchronized { return super.products }! }
    
    override func onProduce(_ product: T) -> Bool { return self.synchronized { super.onProduce(product) }! }
    
    override func onComplete() -> Bool { return self.synchronized { super.onComplete() }! }
    
    override func onError(_ error: Error) -> Bool { return self.synchronized { super.onError(error) }! }
    
}
