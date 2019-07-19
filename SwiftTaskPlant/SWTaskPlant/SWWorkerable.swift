//
//  SWWorkerable.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit


protocol SWWorkarable: class {
    associatedtype Product
    func submit(_ event: SWEvent<Product>)
}

extension SWWorkarable {
    func submitProduce(_ product: Product) {
        self.submit(SWEvent.produce(product))
    }
    
    func submitComplete() {
        self.submit(SWEvent.complete)
    }
    
    func submitError(_ error: Error) {
        self.submit(SWEvent.error(error))
    }
    
    func submitProgress(_ progress: Double) {
        self.submit(SWEvent.progress(progress))
    }
}
