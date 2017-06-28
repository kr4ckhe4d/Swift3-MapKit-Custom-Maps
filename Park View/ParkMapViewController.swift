//
//  ParkMapViewController.swift
//  Park View
//
//  Created by Niv Yahel on 2014-11-09.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

enum MapType: Int {
  case standard = 0
  case hybrid
  case satellite
}

class ParkMapViewController: UIViewController {
  
@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
  
    var selectedOptions = [MapOptionsType]()
    var park = Park(filename: "MagicMountain")
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude
        
        // Get distance from one corner to the opposite corner.
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let region = MKCoordinateRegionMake(park.midCoordinate, span)
        mapView.region = region
    }
  
    func loadSelectedOptions() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        for option in selectedOptions {
            switch (option) {
            case .MapOverlay:
                addOverlay()
            case .MapPins:
                addAttractionPins()
            default:
                break
            }
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue,   sender: Any?) {
        let optionsViewController = segue.destination as! MapOptionsViewController
        optionsViewController.selectedOptions = selectedOptions
    }
  
    @IBAction func closeOptions(_ exitSegue:  UIStoryboardSegue) {
        let optionsViewController = exitSegue.source as!    MapOptionsViewController
        selectedOptions = optionsViewController.selectedOptions
        self.loadSelectedOptions()
    }
  
    @IBAction func mapTypeChanged(_ sender: AnyObject) {
        let mapType = MapType(rawValue: mapTypeSegmentedControl.selectedSegmentIndex)
        switch (mapType!) {
        case MapType.standard:
            mapView.mapType = .standard
        case MapType.hybrid:
            mapView.mapType = .hybrid
        case MapType.satellite:
            mapView.mapType = .satellite
        }
    }
    
    func addOverlay(){
        let overlay = ParkMapOverlay(park: park)
        mapView.add(overlay)
    }
    
    func addAttractionPins(){
        let filePath = Bundle.main.path(forResource: "MagicMountainAttractions", ofType: "plist")
        var attractions = [NSDictionary]()
        let attractions1 = NSArray(contentsOfFile: filePath!)

        for attraction in attractions1! {
            attractions.append(attraction as! NSDictionary)
        }
        
        for attraction in attractions {
            let point = CGPointFromString(attraction["location"] as! String)
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
            let title = attraction["name"] as! String
            let typeRawValue = Int((attraction["type"] as! String))
            let type = AttractionType(rawValue: typeRawValue!)!
            let subtitle = attraction["subtitle"] as! String
            let annotation = AttractionAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            mapView.addAnnotation(annotation)
        }
        
        
        
    }
}

// MARK: - Map View delegate

extension ParkMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ParkMapOverlay{
            let magicMountainInage = UIImage(named: "overlay_park")
            let overlayView = ParkMapOverlayView(overlay: overlay, overlayImage: magicMountainInage!)
            
            return overlayView
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = AttractionAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationView.canShowCallout = true
        return annotationView
    }
}
