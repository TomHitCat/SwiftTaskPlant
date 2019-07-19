//
//  ViewController.swift
//  SwiftTaskPlant
//
//  Created by developer on 2019/7/17.
//  Copyright © 2019 Atomic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func testFuture(_ sender: Any) {
        var diff: TimeInterval = 0
        for _ in 0..<10000 {
            let begain_time = Date.init().timeIntervalSince1970
            let future: SWFuture = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_LOOP)
            DispatchQueue.global().async {
                future.set(result: 1)
            }
            future.get()
            let end_time = Date.init().timeIntervalSince1970
            diff += (end_time - begain_time)
        }
        print("Fast execute---:\(diff)")
    }
    
    @IBAction func fast_idel(_ sender: Any) {
        var diff: TimeInterval = 0
        for _ in 0..<10000 {
            let begain_time = Date.init().timeIntervalSince1970
            let future: SWFuture = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.LOOP_AND_IDLE)
            DispatchQueue.global().async {
                future.set(result: 1)
            }
            future.get()
            let end_time = Date.init().timeIntervalSince1970
            diff += (end_time - begain_time)
        }
        print("Fast_Idel execute---:\(diff)")
    }
    
    @IBAction func testIdle(_ sender: Any) {
        var diff: TimeInterval = 0
        for _ in 0..<10000 {
            let begain_time = Date.init().timeIntervalSince1970
            let future: SWFuture = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
            DispatchQueue.global().async {
                future.set(result: 1)
            }
            future.get()
            let end_time = Date.init().timeIntervalSince1970
            diff += (end_time - begain_time)
        }
        print("Idel execute---:\(diff)")
    }
    
    @IBAction func queueSize(_ sender: Any) {
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
    }
}

