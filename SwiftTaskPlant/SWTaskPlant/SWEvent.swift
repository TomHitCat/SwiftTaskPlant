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

