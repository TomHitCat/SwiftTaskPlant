//
//  SWRingQueue.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/18.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class SWRingQueue<T> {
    private var lastWrite: Int = 0
    
    private var queueSize: Int = 0
    
    private var size: Int = 0
    
    private var queue: ContiguousArray<T?>
    
    private var originSize: Int = 0
    
    private let resizeFactor: Int = 2
    
    private let minmum_capacity: Int = 5
    
    private var nextReadIndex: Int {
        let readIndex = lastWrite - size
        return readIndex < 0 ? queueSize - (size - lastWrite) : readIndex
    }
    
    var count: Int { return size }
    
    var capacity: Int { return queueSize }
    
    init(capacity: Int) {
        queueSize = capacity < minmum_capacity ? minmum_capacity : capacity
        queue = ContiguousArray<T?>.init(repeating: nil, count: queueSize)
        originSize = queueSize
    }
    
    convenience init() { self.init(capacity: 0) }
    
    private func resize(new_size: Int) {
        var new_queue: ContiguousArray<T?> = ContiguousArray.init(repeating: nil, count: new_size)
        let readIndex = nextReadIndex
        let neck = queueSize - readIndex
        let ahead = min(size, neck)
        let foot = size - ahead
        new_queue[0..<ahead] = queue[readIndex..<readIndex + ahead]
        new_queue[ahead..<ahead+foot] = queue[0..<foot]
        queueSize = new_size
        lastWrite = size
        queue = new_queue
    }
    
    func enqueue(item: T) {
        if size >= queueSize {
            let new_size: Int = queueSize * resizeFactor == 0 ? resizeFactor : queueSize * resizeFactor
            resize(new_size: new_size)
        }
        size += 1
        queue[lastWrite] = item
        lastWrite = lastWrite + 1 < queueSize ? lastWrite + 1 : 0
    }
    
    func dequeue() -> T? {
        let readIndex = nextReadIndex
        let result = queue[readIndex]
        defer {
            if queueSize - size > originSize * resizeFactor {
                let gauge = Int((queueSize - size - 1) / originSize)
                resize(new_size: queueSize - gauge * originSize)
            }
        }
        size = size - 1 >= 0 ? size - 1 : 0
        return result
    }
    
    func dequeues(_ executor: (T?) -> Void) {
        while size - 1 > 0 {
            executor(self.dequeue())
        }
    }
}
