//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

//  Filter Implementation
//      Filter By Category
//      Filter By Deals
//  Additional Information 
//  Deals, GiftCards, Eat24
//  Get Directions in apple maps
//
//  Loading Animation
//  Make It Look Pretty
//  Favorite Restaurants

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIScrollViewDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet var businessTableView: UITableView!

    var businesses: [Business]!
    
    var offsetAccumulator: Int = 0
    
    var filteredResults: [Business]!
    
    var searchController: UISearchController!
    
    var loadingMoreView: InfiniteScrollActivityView?
    
    let DEFAULT_SEARCH_TERM = "Food"
    
    var currentSearchTerm: String!
    
    var currentCategories: [String]?
    
    var isMoreDataLoading: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchOptions = ["categories": nil, "deals": nil, "searchTerm": DEFAULT_SEARCH_TERM]
        
        currentSearchTerm = DEFAULT_SEARCH_TERM
        
        isMoreDataLoading = false
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        businessTableView.addSubview(loadingMoreView!)
        
        var insets = businessTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        businessTableView.contentInset = insets
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Restaurants"
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName
            : UIColor.whiteColor()], forState: .Normal)

        
        // By default the navigation bar hides when presenting the
        // search interface.  Obviously we don't want this to happen if
        // our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true

        Business.searchWithTerm(0, term: currentSearchTerm, sort: YelpSortMode.Distance, categories: currentCategories ?? nil, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredResults = self.businesses
            self.businessTableView.reloadData()
        })

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }
            
        }
    }
    
    // fix for category change
    func loadMoreData() {
        offsetAccumulator += 10
        Business.searchWithTerm(offsetAccumulator, term: currentSearchTerm, sort: YelpSortMode.Distance, categories: currentCategories ?? nil, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses.appendContentsOf(businesses)
            self.filteredResults = self.businesses
            self.isMoreDataLoading = false;
            self.loadingMoreView!.stopAnimating()
            self.businessTableView.reloadData()
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults != nil ? filteredResults.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell", forIndexPath: indexPath) as! BusinessTableViewCell
        cell.business = filteredResults[indexPath.row]
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            currentSearchTerm = searchText.isEmpty ? DEFAULT_SEARCH_TERM : searchText
            let sortMode = searchText.isEmpty ? YelpSortMode.Distance : YelpSortMode.BestMatched
            offsetAccumulator = 0
            Business.searchWithTerm(0, term: currentSearchTerm, sort: sortMode, categories: currentCategories ?? nil, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.filteredResults = self.businesses
                self.businessTableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = businessTableView.indexPathForCell(cell)
            let business = businesses[indexPath!.row]
            
            let businessDetailViewController = segue.destinationViewController as! BusinessDetailViewController
            businessDetailViewController.business = business
        }
        else {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        }
    }
    
    func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        
        currentCategories = filters["categories"] as? [String]
        Business.searchWithTerm(0, term: currentSearchTerm, sort: YelpSortMode.Distance, categories: currentCategories ?? nil, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredResults = self.businesses
            self.businessTableView.reloadData()
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
