//
//  MoviesTest.swift
//  MoviesTests
//
//  Created by Hassan Gado on 9/14/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import XCTest
@testable import Movies

class MoviesTest: XCTestCase {

   var controller: MovieDetailsViewController = MovieDetailsViewController()

    func testShowDetail() {
        controller.viewDidLoad()
        XCTAssert(true)
        
    }
    
}
