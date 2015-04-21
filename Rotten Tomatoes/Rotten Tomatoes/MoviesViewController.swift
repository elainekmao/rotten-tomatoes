//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Elaine Mao on 4/19/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var refreshControl: UIRefreshControl!

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartTypeSelector: UISegmentedControl!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()

        chartTypeSelector.selectedSegmentIndex = 0
        
        
        self.errorView.alpha = 0

        //let chart_urls = ["http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=", "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey="]
        //let apiKey = "6awnyexqejes5hrmdws4npsr"
        //var selected_url = chart_urls[chartTypeSelector.selectedSegmentIndex]
        //var url_string = selected_url + apiKey
        //var request = NSMutableURLRequest(URL: NSURL(string: url_string)!)
        
        let chart_urls = ["https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json",
            "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"]
        var url_string = chart_urls[chartTypeSelector.selectedSegmentIndex]
        var request = NSMutableURLRequest(URL: NSURL(string: url_string)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.movies = (json["movies"] as? [NSDictionary])
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                if self.movies == nil {
                    self.errorView.alpha = 0.8
                }
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as! String
        
        var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let image_url = NSURL(string: url)
        
        
        cell.posterView.alpha = 0
        cell.posterView.setImageWithURL(image_url)
        UIView.animateWithDuration(1.5, animations: {
            cell.posterView.alpha = 1.0
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func onSelectionChanged(sender: AnyObject) {
        SVProgressHUD.show()
        //let chart_urls = ["http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=", "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey="]
        //let apiKey = "6awnyexqejes5hrmdws4npsr"
        //var selected_url = chart_urls[chartTypeSelector.selectedSegmentIndex]
        //var url_string = selected_url + apiKey
        //var request = NSMutableURLRequest(URL: NSURL(string: url_string)!)
        
        let chart_urls = ["https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json",
            "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"]
        var url_string = chart_urls[chartTypeSelector.selectedSegmentIndex]
        var request = NSMutableURLRequest(URL: NSURL(string: url_string)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.movies = (json["movies"] as? [NSDictionary])
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                if self.movies == nil {
                    self.errorView.alpha = 0.8
                }
            }
        }
    }
}

