//
//  SWTaskCradle.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/24.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTaskCradle<T>: SWTask<T> {
    
    private var _products: [T] = []
    
    var products: [T] { return _products }
    
    var count: Int { return _products.count }
    
    override func onProduce(_ product: T) -> Bool {
        if isFinish() || !canFillFilter(product) { return false }
        self._products.append(product)
        return true
    }
    
}


class SWTaskCradleSafe<T>: SWTaskCradle<T> {
    
    override var count: Int { return self.synchronized { super.count }! }
    
    override var products: [T] { return self.synchronized { super.products }! }
    
    override func onProduce(_ product: T) -> Bool { return self.synchronized { super.onProduce(product) }! }
    
    override func onComplete() -> Bool { return self.synchronized { super.onComplete() }! }
    
    override func onError(_ error: Error) -> Bool { return self.synchronized { super.onError(error) }! }
    
}
