//
//  ViewModelsTests.swift
//  MoviesTests
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import XCTest
@testable import Movies

class ViewModelsTests: XCTestCase,ViewModelDelegate {

    private var viewModel: ViewModel!
    override func setUp() {
        viewModel  = ViewModel(delegate: self)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testfetchMovieNowPlaying() {
       viewModel.fetchMovie()
    }
    
    func testSearchMovie(){
        viewModel.searchForMoview(query: "Die Hard")
    }
    func testRestCounters(){
        viewModel.resetCounter()
        XCTAssert(viewModel.currentMoviesCount == 0)
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?){
        
        XCTAssert(((viewModel?.totalCount) != nil))
        
    }
    func onFetchFailed(with reason: String){
         XCTFail()
    }

}
