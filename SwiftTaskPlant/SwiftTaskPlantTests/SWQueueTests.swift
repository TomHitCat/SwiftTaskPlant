//
//  SWQueueTests.swift
//  SwiftTaskPlantTests
//
//  Created by developer on 2019/7/19.
//  Copyright © 2019 Atomic. All rights reserved.
//

import XCTest
@testable import SwiftTaskPlant

class SWQueueTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQueueEmpty() {
        let queue: SWRingQueue<Int> = SWRingQueue.init(capacity: 0)
        assert(queue.dequeue() == nil, "Empty queue's dequeue should be nil")
        queue.enqueue(item: 1)
        queue.enqueue(item: 2)
        queue.enqueue(item: 3)
        queue.enqueue(item: 4)
        queue.enqueue(item: 1)
        queue.enqueue(item: 2)
        queue.enqueue(item: 3)
        queue.enqueue(item: 4)
        queue.enqueue(item: 1)
        queue.enqueue(item: 2)
        queue.enqueue(item: 3)
        queue.enqueue(item: 4)
        assert(queue.dequeue()! == 1, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 2, "Dequeue's value is not 2")
        assert(queue.dequeue()! == 3, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 4, "Dequeue's value is not 2")
        assert(queue.dequeue()! == 1, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 2, "Dequeue's value is not 2")
        assert(queue.dequeue()! == 3, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 4, "Dequeue's value is not 2")
        assert(queue.dequeue()! == 1, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 2, "Dequeue's value is not 2")
        assert(queue.dequeue()! == 3, "Dequeue's value is not 1")
        assert(queue.dequeue()! == 4, "Dequeue's value is not 2")
        assert(queue.dequeue() == nil, "Dequeue's value is not nil")
        assert(queue.dequeue() == nil, "Dequeue's value is not nil")
        assert(queue.dequeue() == nil, "Dequeue's value is not nil")
        assert(queue.dequeue() == nil, "Dequeue's value is not nil")
        assert(queue.count == 0, "Dequeue's count is not 0")
    }
    
    func testQueueSize() {
        let queue = SWRingQueue<Int>.init(capacity: 10)
        for one in 0..<300 {
            queue.enqueue(item: one)
        }
        
        for one in 0..<300 {
            let value = queue.dequeue()
            assert(value != nil, "Dequeue's value should not be nil")
            assert(value == one, "Dequeue's value is not correct")
        }
        assert(queue.capacity == 20, "Queue's queue size is not correct")
        assert(queue.count == 0, "Dequeue's count should be 0")
    }
    
    func testQueueInter() {
        struct TestData {
            var data: Int
        }
        let queue = SWRingQueue<TestData>.init()
        for one in 0..<500 {
            queue.enqueue(item: TestData.init(data: one))
            let td = queue.dequeue()
            assert(td != nil, "Dequeue's value should not be nil")
            assert(td!.data == one, "Dequeue's value not correct")
        }
        assert(queue.capacity == 5, "Queue's queue size is not correct")
        assert(queue.count == 0, "Dequeue's count should be 0")
        
        var testDataStore: [TestData] = []
        for one in 0..<30 {
            let data = TestData.init(data: one)
            queue.enqueue(item: data)
            testDataStore.append(data)
        }
        
        for _ in 0..<3 {
            let data = testDataStore.remove(at: 0)
            let comp = queue.dequeue()
            assert(comp != nil, "Dequeue's value should not be nil")
            assert(data.data == comp!.data, "Dequeue's value not correct")
        }
        
        for one in 30..<60 {
            let data = TestData.init(data: one)
            queue.enqueue(item: data)
            testDataStore.append(data)
        }
        
        for _ in 0..<3 {
            let data = testDataStore.remove(at: 0)
            let comp = queue.dequeue()
            assert(comp != nil, "Dequeue's value should not be nil")
            assert(data.data == comp!.data, "Dequeue's value not correct")
        }
        
        for one in 30..<60 {
            let data = TestData.init(data: one)
            queue.enqueue(item: data)
            testDataStore.append(data)
        }
        
        for _ in 0..<3 {
            let data = testDataStore.remove(at: 0)
            let comp = queue.dequeue()
            assert(comp != nil, "Dequeue's value should not be nil")
            assert(data.data == comp!.data, "Dequeue's value not correct")
        }
        
        for one in 0..<10 {
            let begain = one * 30 + 60
            for index in begain..<begain + 30 {
                let data = TestData.init(data: index)
                queue.enqueue(item: data)
                testDataStore.append(data)
            }
            for _ in 0..<3 {
                let data = testDataStore.remove(at: 0)
                let comp = queue.dequeue()
                assert(comp != nil, "Dequeue's value should not be nil")
                assert(data.data == comp!.data, "Dequeue's value not correct")
            }
        }
        
        while(testDataStore.count > 0) {
            let data = testDataStore.remove(at: 0)
            let comp = queue.dequeue()
            assert(comp != nil, "Dequeue's value should not be nil")
            assert(data.data == comp!.data, "Dequeue's value not correct")
        }
        assert(queue.dequeue() == nil, "Dequeue's value should be nil")
    }
}
