//
//  SWTaskEmpty.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/24.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWTaskEmpty<T>: SWTask<T> {
    override func onProduce(_ product: T) -> Bool {
        return canFillFilter(product)
    }
}

class SWTaskEmptySafe<T>: SWTask<T> {
    override func onProduce(_ product: T) -> Bool { return self.synchronized { super.onProduce(product) }! }
}
