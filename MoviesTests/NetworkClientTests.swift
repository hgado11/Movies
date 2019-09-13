//
//  NetworkClientTests.swift
//  NetworkClientTests
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import XCTest
@testable import Movies

class NetworkClientTests: XCTestCase {

    func testDataResponsErrorDecoding(){
        XCTAssertEqual(DataResponseError.decoding.reason,"An error occurred while decoding data")
    }
    func testDataResponsErrorNetwork(){
        XCTAssertEqual(DataResponseError.network.reason,"An error occurred while fetching data ")
    }

    func testBuildURLForNowPlaying(){
        let nowPlayingURL =  NetworkClient().buildUrl(apiEndpoint: .NowPlaying, page: 2, name: "")
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=c1b0f32d42c1e702b7cc599368826aec&page=2") 
        XCTAssertEqual(nowPlayingURL, expectedURL)
    }
    func testBuildURLForSearch(){
        let nowPlayingURL =  NetworkClient().buildUrl(apiEndpoint: .SearchMovie, page: 1, name: "Die Hard")
        let expectedURL = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=c1b0f32d42c1e702b7cc599368826aec&query=Die%20Hard&page=1")
        XCTAssertEqual(nowPlayingURL, expectedURL)
    }
    func testGetNowPlayingMovie(){
        let client = NetworkClient()
        
        client.getMovies { (result) in
            switch result{
            case .success(let movies):
                XCTAssert(movies.movies.count > 0)
            case .failure(_):
                XCTFail()
            }
        }
        
    }
    func testGetNowPlayingMovieWithPages(){
        let client = NetworkClient()
        client.getMovies(page: 2) { (result) in
            switch result{
            case .success(let movies):
                XCTAssert(movies.movies.count > 0)
            case .failure(_):
                XCTFail()
            }
            
        }
        
        
    }
    func testGetSearchMovie(){
        let client = NetworkClient()
        
        client.getMovies(apiendPoint: .SearchMovie, movie: "Die Hard")  { (result) in
            switch result{
            case .success(let movies):
                XCTAssert(movies.movies.count > 0)
            case .failure(_):
                XCTFail()
            }
        }
        
    }
    func testGetSearchMovieWithPages(){
        let client = NetworkClient()
        
        client.getMovies(apiendPoint: .SearchMovie, movie: "Die Hard",page: 2)  { (result) in
            switch result{
            case .success(let movies):
                XCTAssert(movies.movies.count > 0)
            case .failure(_):
                XCTFail()
            }
        }
        
    }

}
