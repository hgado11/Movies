//
//  Movies.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation
// MARK: - Movies
struct Movies: Codable {
    let movies: [Movie]
    let page, total_pages: Int
    let dates: Dates
    let total_results: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case total_results
        case dates
        case total_pages
    }
}
