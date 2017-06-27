//
//  ParkMapOverlayView.swift
//  Park View
//
//  Created by Nipuna's MacMini on 6/27/17.
//  Copyright © 2017 Chris Wagner. All rights reserved.
//

/**
    A MKOverlayRenderer is really just a special kind of UIView, as it inherits from UIView. 
    However, you don’t add an MKOverlayRenderer directly to the MKMapView.
    This is an object the MapKit framework expects you to provide. 
    After you give it to MapKit, it will render it as an overlay on top of the map.
 */

import Foundation
import MapKit

class ParkMapOverlayView: MKOverlayRenderer {
    var overlayImage = UIImage()
    
    init(overlay:MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let imageReference = overlayImage.cgImage
        
        let theMapRect = overlay.boundingMapRect
        let theRect = rect(for: theMapRect)
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -theRect.size.height)
        context.draw(imageReference!, in: theRect)
    }
}
