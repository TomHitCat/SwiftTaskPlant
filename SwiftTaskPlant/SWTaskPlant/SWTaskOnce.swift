//
//  SWTaskEmpty.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/23.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTaskOnce<T>: SWTask<T> {
    
    private var result: T?
    
    private var isAssign: Bool = false
    
    override func onProduce(_ product: T) -> Bool {
        if isAssign || isFinish() || !canFillFilter(product) { return false }
        result = product
        isAssign = true
        return true
    }
 
    func hasResult() -> Bool { return isAssign }
    
    func getResult(result: inout T?) -> Bool {
        if hasResult() {
            result = self.result
            return true
        }
        return false
    }
}


class SWTaskOnceSafe<T>: SWTaskOnce<T> {
    
    override func onProduce(_ product: T) -> Bool { return self.synchronized { super.onProduce(product) }! }
    
    override func onComplete() -> Bool { return self.synchronized { super.onComplete() }! }
    
    override func onError(_ error: Error) -> Bool { return self.synchronized { super.onError(error) }! }
    
    override func hasResult() -> Bool { return self.synchronized { super.hasResult() }! }
    
}
