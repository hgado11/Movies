//
//  DataResponseError.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation
enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
