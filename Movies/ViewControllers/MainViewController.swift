//
//  MainViewController.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import UIKit

class MainViewController: BaseCollectionViewController  {
    
    // MARK: - Properties
    
    private var viewModel: ViewModel!
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationControllerWithSearch()
        self.loadMovies()
        
        
        
    }
    // MARK: - Private methods
    private func setUpNavigationControllerWithSearch(){
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Movies"
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = true // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        collectionView.prefetchDataSource = self
        definesPresentationContext = true
    }
    
    func loadMovies(){
        viewModel  = ViewModel(delegate: self)
        viewModel.fetchMovie()
    }
}
extension MainViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMovie()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:self.reuseIdentifier , for: indexPath) as? MovieCollectionViewCell else{
            fatalError("Couldn't Load Cell")
        }
        if !isLoadingCell(for: indexPath){
        let movie:Movie = viewModel.movie(at: indexPath.row)
            if let poster = movie.posterPath{
                cell.configCell(imageurl:poster)
                
            }
            
        }
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie:Movie = viewModel.movie(at: indexPath.row)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailView = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else{
                return
            }
            detailView.movie = movie
            self.navigationController!.pushViewController(detailView, animated: true)
        
    }
    
}
// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchControllerDelegate

extension MainViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        viewModel.resetCounter()
        collectionView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.resetCounter()
        viewModel.fetchMovie()
    }
    
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
    func findMovie(movie:String)  {
        viewModel.searchForMoview(query: movie)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        findMovie(movie: searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet))
        
        
    }
    
}
extension MainViewController:ViewModelDelegate{
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
       
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentMoviesCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}


