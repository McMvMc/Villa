//
//  ViewController.swift
//  Villa
//
//  Created by McTavish Wang on 16/1/2.
//  Copyright © 2016年 Luohan. All rights reserved.
//

// roommate: roommate request is a property of a user,
//              when a user follows a property / try to contact / create roommate request
//              they will need to fill out information form (enabling us to sell the informaiton and promote)

/* data schema

    user
        - email
        - sex
        - first name
        - last name
        - city                      // for roommates
        - country
        - year
        - self description
        - roommate requirement
        - renting properties id []
        - following properties id []
        - looking for []     // 1, 2, 3, 4 people

    properties
        - lease
            - address
            - amenities uncovered[]
            - amenities covered[]
            - major []      // Engineering / Business /...
            - availability
            - bathroom
            - bedroom
            - parking
            - description
            - latitude
            - longitude
            - owner user id
            - photo []
            - price
            - email []
            - number []
            - facebook      ? what type
            - roommates needed user id []        // for roommates

        - sublease      // feature that imports the existing properties
            - address
            - amenities uncovered[]
            - amenities covered[]
            - major []
            - bathroom
            - bedroom
            - parking
            - description
            - latitude
            - longitude
            - owner user id
            - start data
            - end date
            - photo []
            - price
            - email []
            - number []
            - facebook      ? what type
            - wechat
            - roommates needed user id []        // for roommates

    official lease list         // for importing existing properties
            - key: property name, value: true

*/


import UIKit
import CoreLocation

class HomeController: UIViewController, CLLocationManagerDelegate, UITabBarDelegate{

    @IBOutlet weak var tv: UITableView!
    
    
    
    var rc: UIRefreshControl!
    
    var db = Firebase(url: "https://testrealtime.firebaseio.com/")
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initFeatures()
        
        // load data
        readData()
        
        db.observeEventType(.ChildChanged, withBlock: { snapshot in
            
            // if there's a change in value, read the value in users
            self.refreshData()
            
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initFeatures(){
        
        // register custom table cell
        self.tv.registerNib(UINib(nibName: "PropertyTableViewCell", bundle: nil), forCellReuseIdentifier: "PropertyCell")
        
        rc = UIRefreshControl()
        rc.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        rc.attributedTitle = NSAttributedString(string: "release to refresh")
        tv.addSubview(rc)
        
        //init the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //start getting the location
        self.locationManager.startUpdatingLocation()
        print("start updating location")
    
    }
    
    func refreshData(){
        readData()
        self.rc.endRefreshing()
    }
    
    
    // 还需要把lease和sublease归到个目录下， 减少流量消耗
    
    func readData(){
        // load data
        db.observeEventType(.Value, withBlock: { snapshot in
            
            // go to the family and get the usernames of the family members
            self.userInfo = snapshot.childSnapshotForPath("Families/\(self.family)").value as! [String:String]
            
            self.members = [familyMember]()
            self.imageString = [String]()
            // now have the members, go get their locations
            for (AutoID,userID) in self.userInfo{
                
                if userID == self.uid{continue}
                var memberLongi = (snapshot.childSnapshotForPath("users/\(userID)/CurrentLongitude").value as! NSString).doubleValue
                var memberLati = (snapshot.childSnapshotForPath("users/\(userID)/CurrentLatitude").value as! NSString).doubleValue
                var memberRole = snapshot.childSnapshotForPath("users/\(userID)/Role").value as! String
                var memberName = (snapshot.childSnapshotForPath("users/\(userID)/FirstName").value as! String) + " " +
                    (snapshot.childSnapshotForPath("users/\(userID)/LastName").value as! String)
                var memberPic = snapshot.childSnapshotForPath("Images/\(userID)").value as! String
                
                var newMember = familyMember(newLongi: memberLongi, newLati: memberLati, newRole: memberRole, newName: memberName)
                
                self.members.append(newMember)
                self.imageString.append(memberPic)
            }
            
            self.tableView.reloadData()
        })
        
        
    }
    
    
}

