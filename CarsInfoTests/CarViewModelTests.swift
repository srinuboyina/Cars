//
//  CarViewModelTests.swift
//  CarsInfoTests
//
//  Created by apple on 25/09/22.
//

import XCTest
@testable import CarsInfo

class MockReachability: ReachabilityProtocol {
    func isConnectedToNetwork() -> Bool {
        return false
    }
}

final class CarViewModelTests: XCTestCase {
    
    let viewModel = CarsViewModel(reachability: MockReachability())

    override class func setUp() {
        XCTAssert(viewModel.cars.count == 0)
    }
    
    func testFetchCars() {
        viewModel.fetchCars()
    }
}
