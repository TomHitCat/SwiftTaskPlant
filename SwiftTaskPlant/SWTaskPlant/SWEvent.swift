//
//  SWEvent.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

enum SWEvent<Product> {
    case produce(Product)
    case progress(Double)
    case error(Error)
    case complete
}

extension SWEvent {
    var isComplete: Bool {
        if case .complete = self {
            return true
        }
        return false
    }
    
    var error: Error? {
        if case .error(let err) = self {
            return err
        }
        return nil
    }
    
    var product: Product? {
        if case .produce(let pro) = self {
            return pro
        }
        return nil
    }
}
