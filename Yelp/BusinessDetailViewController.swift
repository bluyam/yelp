//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Kyle Wilson on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    var business: Business!
    
    var actions = [String: AnyObject?]()
    
    var actionNames = [[String]]()
    
    var locationManager : CLLocationManager!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var businessMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        navigationController!.navigationBar.topItem!.title = business.name
        
        actionNames = [["Get Directions", "functionName"], ["Call", "function"], ["Visit Website", "function"]]
        
        let location = [business.longitude!, business.latitude!]
        let phone = business.phone ?? nil
        let mobileUrl = business.mobileUrl ?? nil
        
        actions["location"] = location
        actions["phone"] = phone ?? "Not Available"
        actions["mobileUrl"] = mobileUrl ?? "Not Available"
        
        loadMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        businessMapView.setRegion(region, animated: false)
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        businessMapView.addAnnotation(annotation)
    }

    func loadMap() {
        let centerLocation = CLLocation(latitude: (business.latitude?.doubleValue)!, longitude: (business.longitude?.doubleValue)!)
        goToLocation(centerLocation)

        addAnnotationAtCoordinate(centerLocation.coordinate, title: business.name!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell") as! ActionCell
        cell.actionNameLabel.text = actionNames[indexPath.row][0]
        print(actionNames[indexPath.row][0])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0: //get directions
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(business.latitude as! CLLocationDegrees, business.longitude as! CLLocationDegrees)
            print("\(coordinate)")
            let placeMark: MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let destination: MKMapItem = MKMapItem(placemark: placeMark)
            destination.name = business.name
            if destination.respondsToSelector("openInMapsWithLaunchOptions:") {
                destination.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            break;
        case 1: //call
            if business.phone != nil {
                let url: NSURL = NSURL(string: "tel://"+business.phone!)!
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
                else {
                    let alert: UIAlertView = UIAlertView(title: "No Call Functionality Available", message: "Sorry about that.", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "")
                    alert.show()
                }
                
            }
            else {
                let alert: UIAlertView = UIAlertView(title: "No Phone Number Provided", message: "Sorry about that.", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "")
                alert.show()
            }
            break;
        case 2: //view website
            if business.mobileUrl != nil {
                UIApplication.sharedApplication().openURL(NSURL(string: business.mobileUrl!)!)
            }
            else {
                let alert: UIAlertView = UIAlertView(title: "No Website Provided", message: "Sorry about that.", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "")
                alert.show()
            }
            break;
        default:
            break;
        }
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
