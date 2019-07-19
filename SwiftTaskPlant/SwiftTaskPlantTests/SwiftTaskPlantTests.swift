//
//  SwiftTaskPlantTests.swift
//  SwiftTaskPlantTests
//
//  Created by developer on 2019/7/17.
//  Copyright © 2019 Atomic. All rights reserved.
//

import XCTest
@testable import SwiftTaskPlant

class SwiftTaskPlantFutureTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFutureInitValue() {
        let ft = SWFuture<Int>.init(10)
        assert(ft.get() != nil, "SWFuture.init(value:)'s get should not be nil")
        let exc = XCTestExpectation.init(description: "Must revoke complete callback")
        DispatchQueue.global().async {
            self.wait(for: [exc], timeout:0.05)
        }
        if let result = ft.get()
        {
            exc.fulfill()
            assert(result == 10, "SWFuture's get result is not correct")
        }
    }
    
    func testFutureAsynFast() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_LOOP)
        let excFinish = XCTestExpectation.init(description: "Future Fast cannot finish")
        DispatchQueue.global().async {
            sleep(5)
            ft.set(result: 10)
            excFinish.fulfill()
        }
        
        assert(ft.get() != nil, "SWFuture.init(value:)'s get should not be nil")
        
        if let result = ft.get()
        {
            self.wait(for: [excFinish], timeout:5.030)
            assert(result == 10, "SWFuture's get result is not correct")
        }
    }
    
    func testFutureAsynFastAndIDLE() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.LOOP_AND_IDLE)
        let excFinish = XCTestExpectation.init(description: "Future cannot finish")
        DispatchQueue.global().async {
            sleep(5)
            ft.set(result: 10)
            excFinish.fulfill()
        }
        
        assert(ft.get() != nil, "SWFuture.init(value:)'s get should not be nil")
        
        if let result = ft.get()
        {
            self.wait(for: [excFinish], timeout:5.030)
            assert(result == 10, "SWFuture's get result is not correct")
        }
    }
    
    func testFutureAsynIDLE() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
        let excFinish = XCTestExpectation.init(description: "Future IDLE cannot finish")
        DispatchQueue.global().async {
            sleep(5)
            ft.set(result: 10)
            excFinish.fulfill()
        }
        
        assert(ft.get() != nil, "SWFuture.init(value:)'s get should not be nil")
        
        if let result = ft.get()
        {
            self.wait(for: [excFinish], timeout:5.030)
            assert(result == 10, "SWFuture's get result is not correct")
        }
    }
    
    func testFutureGetTimeout() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
        let excFinish = XCTestExpectation.init(description: "Future Get timeout not finish")
        var result: Int?
        DispatchQueue.global().async {
            self.wait(for: [excFinish], timeout: 5.1)
        }
        ft.get(5, &result)
        excFinish.fulfill()
    }
    
    func testFutureGetTimeoutResult() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
        let excFinish = XCTestExpectation.init(description: "Future Get timeout not finish")
        var result: Int?
        DispatchQueue.global().async {
            sleep(1)
            ft.set(result: 100)
            self.wait(for: [excFinish], timeout: 5.1)
        }
        if ft.get(5, &result)
        {
            assert(result != nil, "SWFuture's get result should not be nil")
            assert(result! == 100, "SWFuture's get result is not correct")
            excFinish.fulfill()
        } else {
            assert(false, "SWFuture's get timeout should success")
        }
    }
    
    func testFutureTryGet() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
        let expire = XCTestExpectation.init(description: "TryGet should finish!!")
        DispatchQueue.global().async {
            self.wait(for: [expire], timeout: 1)
        }
        var value: Int?
        ft.tryGet(&value)
        expire.fulfill()
    }
    
    func testFutureTryGetValue() {
        let ft = SWFuture<Int>.init(type: SWFuture.SWFutureBlockType.ONLY_IDLE)
        let expire = XCTestExpectation.init(description: "TryGet should finish!!")
        DispatchQueue.global().async {
            sleep(1)
            ft.set(result: 100)
            self.wait(for: [expire], timeout: 4)
        }
        var result: Int?
        sleep(2)
        if ft.tryGet(&result) {
            assert(result != nil, "SWFuture's tryGet result should not be nil")
            assert(result! == 100, "SWFuture's tryGet result is not correct")
            expire.fulfill()
        } else {
            assert(result != nil, "SWFuture's tryGet cannot get value")
        }
        expire.fulfill()
    }
}
