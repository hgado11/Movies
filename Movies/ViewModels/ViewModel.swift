//
//  ViewModel.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation
protocol ViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ViewModel {
    private weak var delegate: ViewModelDelegate?
    private var movies: [Movie] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    let client = NetworkClient()
    init(delegate: ViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    var currentMoviesCount: Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func resetCounter(){
        self.movies = []
        self.currentPage = 1
        self.total = 0
        isFetchInProgress = false
    }
    
    func fetchMovie() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        client.getMovies(page: self.currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    // 1
                    self.currentPage += 1
                    self.total = response.total_results
                    self.isFetchInProgress = false
                    self.movies.append(contentsOf: response.movies)
                    
                    
                    // 3
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.movies)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    func searchForMoview(query:String){
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        client.getMovies(apiendPoint: .SearchMovie, movie: query, page: self.currentPage){ result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    // 1
                    self.total = response.total_results
                    self.isFetchInProgress = false
                    self.movies = response.movies
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}
