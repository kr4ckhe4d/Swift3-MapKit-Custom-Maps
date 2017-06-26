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
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    func loadSelectedOptions() {
        // To be implemented
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
        // To be implemented
    }
}

// MARK: - Map View delegate

extension ParkMapViewController: MKMapViewDelegate {
}
