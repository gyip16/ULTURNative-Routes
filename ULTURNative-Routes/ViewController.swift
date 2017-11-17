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
import Mapbox
import MapboxDirections
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate
{
    /*
    //this is map view
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    */
    //let manager = CLLocationManager()
    let directions = Directions.shared
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        //set the zoom
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.001,0.001)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        //calculation convert location object to double type
        let vspeed=Double(location.speed)
        let speedh=round(vspeed*3.6)
        if(speedh<0){
            speedLabel.text="0  km/h"}
        else{
            speedLabel.text=String(speedh)+"  km/h"
        }
        
        self.map.showsUserLocation = true
        
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        manager.delegate = self
        map.delegate = self
        mapRoute()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()*/
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House"),
            ]
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
        options.includesSteps = true
        
        let task = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first {
                print("Route via \(leg):")
                
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                
                print("Distance: \(route.distance)m; ETA: \(formattedTravelTime!)")
                
                for step in leg.steps {
                    print("\(step.instructions)")
                    print("\(step.intersections![step.intersections!.count-1].location.latitude)    \(step.intersections![step.intersections!.count-1].location.longitude)")
                    //print("\(legsteps["intersection"][legsteps["intersection"].count-1]["location"][0])   \(legsteps["intersection"][legsteps["intersection"].count-1]["location"][1])")
                    print("— \(step.distance)m —")
                    
                    let point = MGLPointAnnotation()
                    point.coordinate = step.intersections![step.intersections!.count-1].location
                    point.title = "Hello!"
                    point.subtitle = "\(step.intersections![step.intersections!.count-1].location.latitude)    \(step.intersections![step.intersections!.count-1].location.longitude)"
                    mapView.addAnnotation(point)
                }
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    mapView.addAnnotation(routeLine)
                    mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                }
            }
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    /*
    func mapRoute(){

        let sourceLocation = CLLocationCoordinate2D(latitude: 49.257764, longitude: -123.107053)
        let destinationLocation = CLLocationCoordinate2D(latitude: 49.258062, longitude: -123.107450)
   
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "hello world"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Vancouver"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.map.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            //let rect = route.polyline.boundingMapRect
            //self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    */
}

