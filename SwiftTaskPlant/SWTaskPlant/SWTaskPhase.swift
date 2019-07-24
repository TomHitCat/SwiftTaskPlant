//
//  SWTaskPhase.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/22.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

enum SWTaskPhase: Int32 {
    typealias RawValue = Int32
    case SWTaskCreated = 1
    case SWTaskExecution = 2
    case SWTaskComplete = 3
    case SWTaskAbort = 4
    
    private static func checkPhasesToProcess(_ phase: AtomicInt32, _ phaseEnum: SWTaskPhase) -> Bool {
        switch phaseEnum {
        case .SWTaskCreated:
            return compareAndSet(phase, compare: 0, set: phaseEnum.rawValue)
        case .SWTaskExecution:
            return compareAndSet(phase, compare: SWTaskPhase.SWTaskCreated.rawValue, set: phaseEnum.rawValue)
        case .SWTaskComplete:
            return compareAndSet(phase, compare: SWTaskPhase.SWTaskExecution.rawValue, set: phaseEnum.rawValue)
        case .SWTaskAbort:
            return compareAndSet(phase, compare: SWTaskPhase.SWTaskExecution.rawValue, set: phaseEnum.rawValue)
        }
    }
    
    static func toCreated(_ phase: AtomicInt32) -> Bool {
        return self.checkPhasesToProcess(phase, .SWTaskCreated)
    }
    
    static func toExecution(_ phase: AtomicInt32) -> Bool {
        return self.checkPhasesToProcess(phase, .SWTaskExecution)
    }
    
    static func toComplete(_ phase: AtomicInt32) -> Bool {
        return self.checkPhasesToProcess(phase, .SWTaskComplete)
    }
    
    static func toError(_ phase: AtomicInt32) -> Bool {
        return self.checkPhasesToProcess(phase, .SWTaskAbort)
    }
    
    static func isComplete(_ phase: AtomicInt32) -> Bool {
        let current = load(phase)
        return current == self.SWTaskComplete.rawValue
    }
    
    static func isError(_ phase: AtomicInt32) -> Bool {
        let current = load(phase)
        return current == self.SWTaskAbort.rawValue
    }
    
    static func isFinish(_ phase: AtomicInt32) -> Bool {
        let current = load(phase)
        return current == self.SWTaskComplete.rawValue || current == self.SWTaskAbort.rawValue
    }
    
    static func isStarted(_ phase: AtomicInt32) -> Bool {
        let current = load(phase)
        return current >= self.SWTaskExecution.rawValue
    }
    
    static func isExecuting(_ phase: AtomicInt32) -> Bool {
        return compareAndSet(phase, compare:  self.SWTaskExecution.rawValue, set:  self.SWTaskExecution.rawValue)
    }
}
