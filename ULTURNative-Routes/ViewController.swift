//
//  ViewController.swift
//  ULTURNative-Routes
//
//  Created by Etome on 2017-09-29.
//  Copyright © 2017 Etome. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    //this is map view
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        //set the zoom
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        //calculation convert location object to double type
        let vspeed=Double(location.speed)
        let speedh=round(vspeed*3.6)
        speedLabel.text=String(speedh)+"  Km/H"
        
        self.map.showsUserLocation = true
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

