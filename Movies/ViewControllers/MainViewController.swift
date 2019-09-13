//
//  MainViewController.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import UIKit

class MainViewController: BaseCollectionViewController  {
    
    

    
    /// State restoration values.
    enum RestorationKeys: String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    // MARK: - Properties
    var movieList:[Movie]?
    
    private var nowPlayingViewModel: NowPlayingViewModel!
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    /// Restoration state for UISearchController
    var restoredState = SearchControllerRestorableState()
    
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
        nowPlayingViewModel  = NowPlayingViewModel(delegate: self)
        nowPlayingViewModel.fetchMovie()
    }
    
    
}
extension MainViewController: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            nowPlayingViewModel.fetchMovie()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingViewModel.totalCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:self.reuseIdentifier , for: indexPath) as? MovieCollectionViewCell else{
            fatalError("Couldn't Load Cell")
        }
        if !isLoadingCell(for: indexPath){
        let movie:Movie = nowPlayingViewModel.movie(at: indexPath.row)
            cell.configCell(imageurl:movie.posterPath)
            
        }
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie:Movie = nowPlayingViewModel.movie(at: indexPath.row)
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
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        loadMovies()
    }
    
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
    func findMovie(movie:String)  {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        findMovie(movie: searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet))
        
        
    }
    
}
extension MainViewController:NowPlayingViewModelDelegate{
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        if(indexPathsToReload.count > 0){
            collectionView.reloadItems(at: indexPathsToReload)
            
        }else{
            
            collectionView.reloadData()
        }
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= nowPlayingViewModel.currentMoviesCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}


