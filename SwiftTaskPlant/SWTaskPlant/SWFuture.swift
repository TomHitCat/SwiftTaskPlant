//
//  SWFuture.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/17.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit
class SWFuture<T> {
    enum SWFutureBlockType {
        case ONLY_LOOP
        case LOOP_AND_IDLE
        case ONLY_IDLE
    }
    
    private var result: T?
    
    private var flag: AtomicBool
    
    private let wait_type: SWFutureBlockType
    
    private let loop_wait: TimeInterval
    
    private let loop_wait_unit: TimeInterval
    
    private var condition_lock: NSConditionLock = NSConditionLock(condition: 0)
    
    init(_ result: T) {
        loop_wait = 3
        loop_wait_unit = 0.001
        wait_type = .LOOP_AND_IDLE
        self.result = result
        flag = AtomicBool(value: true)
    }
    
    init(type: SWFutureBlockType, wait: TimeInterval = 3, unit: TimeInterval = 0.01) {
        loop_wait = wait
        loop_wait_unit = unit
        wait_type = type
        flag = AtomicBool(value: false)
    }
    
    func set(result: T?) {
        if load(flag) { return }
        condition_lock.lock()
        if load(flag) { return }
        self.result = result
        compareAndSet(flag, compare: false, set: true)
        condition_lock.unlock(withCondition: 1)
    }
    
    @discardableResult
    func get() -> T? {
        if load(flag) { return result }
        if wait_type != .ONLY_IDLE {
            if wait_type == .ONLY_LOOP {
                var least = Date.init().timeIntervalSince1970
                while(!load(flag)) {   // If load/flag are real atomic, will faster than hang the thread?
                    let current = Date.init().timeIntervalSince1970
                    if current - least > loop_wait {
                        least = current
                        // If the task needs long time to execute, ONLY_LOOP mode is not appropriate
                        // If the task is lighter or immediately finished, use this mode to forbidden context switch
                        // In case CPU consuming too much to slow down the performance, free some CPU fragment
                        Thread.sleep(forTimeInterval: loop_wait_unit / loop_wait)
                    }
                }
                return result
            } else {
                let least = Date.init().timeIntervalSince1970
                var current = least
                while(!load(flag) && current - least < Double(loop_wait)) {
                    current = Date.init().timeIntervalSince1970
                }
                if load(flag) { return result }
            }
        }
        condition_lock.lock(whenCondition: 1)
        condition_lock.unlock()
        return result
    }
    
    @discardableResult
    func get(_ timeout: TimeInterval, _ result: inout T?) -> Bool {
        if load(flag) {
            result = self.result
            return true
        }
        if condition_lock.lock(whenCondition: 1, before: Date.init(timeIntervalSinceNow: timeout)) {
            result = self.result
            condition_lock.unlock()
            return true
        } else {
            if load(flag) {
                result = self.result
                return true
            }
            result = nil
            return false
        }
    }
    
    @discardableResult
    func tryGet(_ result: inout T?) -> Bool {
        if load(flag) {
            result = self.result
            return true
        }
        result = nil
        return false
    }
}
