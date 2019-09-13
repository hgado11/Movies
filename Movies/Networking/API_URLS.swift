//
//  API_URLS.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation

//MARK: - URL Strings
struct URL_STRINGS
{
    static let MOVIES_DB_APIKey = "c1b0f32d42c1e702b7cc599368826aec"
    static let BASIC_URL = "https://api.themoviedb.org/3/"
    static let BASIC_NOW_PLAYING = "movie/now_playing"
    static let BASIC_API_KEY_PATH = "?api_key=\(MOVIES_DB_APIKey)"
    static let BASIC_SEARCH_MOVIE = "search/movie"
    static let Now_PLAYING_MOVIES = BASIC_URL + BASIC_NOW_PLAYING + BASIC_API_KEY_PATH
    
    //image path
    static let SMALL_IMAGE_PATH = "https://image.tmdb.org/t/p/w185"
    static let BIG_IMAGE_PATH = "https://image.tmdb.org/t/p/w342"
    
    func getNowPlayingUrl(page:Int) -> String {
        
        var nowPlayingURl = URL_STRINGS.BASIC_URL + URL_STRINGS.BASIC_NOW_PLAYING + URL_STRINGS.BASIC_API_KEY_PATH + "&page=\(page)"
        nowPlayingURl = nowPlayingURl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return nowPlayingURl
    }
    //url path for search movie
    func getMovieSearchUrlWith(movieName: String,page:Int) -> String {
        
        var serachURL = URL_STRINGS.BASIC_URL + URL_STRINGS.BASIC_SEARCH_MOVIE + URL_STRINGS.BASIC_API_KEY_PATH + "&query=\(movieName)&page=\(page)"
        serachURL = serachURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return serachURL
    }
    
}
