//
//  NetworkClient.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation
//MARK:- End points
enum APIEndPoints {
    case NowPlaying
    case SearchMovie
}

final class NetworkClient {
    
    /**
     Build Url for Fetching Movie Database
     - Parameter apiendPoint: switching between NowPlaying and search eandPoint
     - Parameter movie: search query defult empty string
     - Parameter page: page number default 1
     **/
     func buildUrl(apiEndpoint:APIEndPoints,page:Int,name:String)->URL{
        var urlString = ""
        
        switch apiEndpoint {
        case .NowPlaying:
            urlString = URL_STRINGS().getNowPlayingUrl(page: page)
        case .SearchMovie:
            urlString = URL_STRINGS().getMovieSearchUrlWith(movieName: name, page: page)
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Wrong URL")
        }
        return url
    }
    
    /**
     Futch Movies from Movie Database
     - Parameter apiendPoint: switching between NowPlaying and search eandPoint
     - Parameter movie: search query defult empty string
     - Parameter page: page number default 1
     - Parameter completion: escaping closures to handle Success and failure
     **/
    func getMovies(apiendPoint:APIEndPoints = .NowPlaying,movie:String = "",page:Int = 1 ,completion: @escaping (Result<Movies, DataResponseError>) -> Void) {
    
        do {
            let data = try Data(contentsOf: buildUrl(apiEndpoint: apiendPoint, page: page, name: movie), options: Data.ReadingOptions.uncached)
            
            do {
                let movies = try JSONDecoder().decode(Movies.self, from:data)
                completion(Result.success(movies as Movies))
            } catch let parseError {
                completion(Result.failure(DataResponseError.decoding))
            }
            
            
            
        } catch {
            completion(Result.failure(DataResponseError.network))
        }
    }
}
