//
//  SWUtilAtomic.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/17.
//  Copyright © 2019 Atomic. All rights reserved.
//
import class Foundation.NSLock

final class AtomicBool: NSLock {
    fileprivate var value: Bool
    
    init(value: Bool) {
        self.value = value
    }
}

final class AtomicInt32: NSLock {
    fileprivate var value: Int32
    
    init(value: Int32 = 0) {
        self.value = value
    }
}

@discardableResult
@inline(__always)
func atomic_add(_ atomic_int32: AtomicInt32, _ value: Int32) -> Int32 {
    atomic_int32.lock()
    let ovl = atomic_int32.value
    atomic_int32.value += value
    atomic_int32.unlock()
    return ovl
}

@discardableResult
@inline(__always)
func atomic_sub(_ atomic_int32: AtomicInt32, _ value: Int32) -> Int32 {
    atomic_int32.lock()
    let ovl = atomic_int32.value
    atomic_int32.value -= value
    atomic_int32.unlock()
    return ovl
}

@discardableResult
@inline(__always)
func increment(_ atomic_int32: AtomicInt32) -> Int32 {
    return atomic_add(atomic_int32, 1)
}

@discardableResult
@inline(__always)
func decrement(_ atomic_int32: AtomicInt32) -> Int32 {
    return atomic_sub(atomic_int32, 1)
}

@inline(__always)
func load(_ atomic_int32: AtomicInt32) -> Int32 {
    atomic_int32.lock()
    let lvl = atomic_int32.value
    atomic_int32.unlock()
    return lvl
}

@inline(__always)
func load(_ atomic_bool: AtomicBool) -> Bool {
    atomic_bool.lock()
    let result = atomic_bool.value
    atomic_bool.unlock()
    return result
}

@discardableResult
@inline(__always)
func compareAndSet(_ atomic_int32: AtomicInt32, compare: Int32, set: Int32) -> Bool {
    var result: Bool = false
    atomic_int32.lock()
    if atomic_int32.value == compare {
        atomic_int32.value = set
        result = true
    }
    atomic_int32.unlock()
    return result
}

@discardableResult
@inline(__always)
func compareAndSet(_ atomic_bool: AtomicBool, compare: Bool, set: Bool) -> Bool {
    var result: Bool = false
    atomic_bool.lock()
    if atomic_bool.value == compare {
        atomic_bool.value = set
        result = true
    }
    atomic_bool.unlock()
    return result
}
