//
//  MapViewController+MKMapViewDelegate.swift
//  BlueMap
//
//  Created by Vinh on 7/27/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation

// MARK: - MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Will be apply LocationManager after
        if userLocation.coordinate.latitude > 0 && userLocation.coordinate.longitude > 0  && curCoordinate == nil {
            curCoordinate = userLocation.coordinate
            self.mapView.setCenter(userLocation.coordinate, zoomLevel: 13, animated: true)
        }else{
            curCoordinate = userLocation.coordinate
        }
    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        //        debugPrint("regionDidChangeAnimated")
//    }
//    
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        //        debugPrint("regionWillChangeAnimated")
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !annotation.isKind(of: MKUserLocation.self ) else { return nil }
        let annotationIdentifier = "identifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        annotationView!.image = UIImage(named: "icon_pin")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        drawRoadButton.isHidden = false
        //update placeSelected value
        guard  let _view = view.annotation as? BMPointAnnotation else { return }
        self.placeSelected = _view.place
        
        //update icon
        view.image = UIImage(named: "icon_pin_selected")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        drawRoadButton.isHidden = true
        //remove all removeOverlays
        mapView.removeOverlays(mapView.overlays)
        
        //reset placeSelected value
        self.placeSelected = nil
        
        //update icon
        view.image = UIImage(named: "icon_pin")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard  let _view = view.annotation as? BMPointAnnotation else { return }
        let placeView = PlaceViewController()
        placeView.place = _view.place
        navigationController?.pushViewController(placeView, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}
