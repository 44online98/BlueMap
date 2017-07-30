//
//  MapViewController.swift
//  Booqed
//
//  Created by Altitude Labs on 5/5/2016.
//  Copyright © 2016 AltitudeLabs. All rights reserved.
//

import UIKit
import MapKit

class BMPointAnnotation: MKPointAnnotation {
    var place : PlaceModel?
}

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ place: PlaceModel)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment  : UISegmentedControl!
    
    var drawRoadButton  = UIButton()
    var resultSearchController: UISearchController!
    var placeSelected   : PlaceModel?
    var listPlace       = [PlaceModel]()
    var listCategory    = [CategoryModel]()
    var heightSegment   : CGFloat  = 30
    var curCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Circle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.requestAPIGetListCharities()
        self.requestAPIGetListCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView(){
        // init navigationBar
        navigationController?.navigationBar.barTintColor        = COLOR.MAIN
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationController?.navigationBar.tintColor           = .white
        navigationController?.navigationBar.isTranslucent       = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_filter"),
                                                            style: .plain, target: self,
                                                            action: #selector(onPressRightBarButton))
        
        // init resultSearchController
        let locationSearchTable =  LocationSearchTable()
        locationSearchTable.parentView = self
        locationSearchTable.handleMapSearchDelegate = self
        
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Tìm kiếm địa điểm"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        resultSearchController.searchBar.delegate = self
        definesPresentationContext = true
        
        
        // init mapView
        mapView.mapType   = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.frame     = CGRect (x: 0 , y: 0  , width: kScreenWidth ,
                                    height: kScreenHeight - kStatusBarHeight - kNavBarHeight - heightSegment  )
        drawRoadButton.frame = CGRect(x: mapView.width - 30 - kMargin , y: 50, width: 30,
                                      height: 30)
        drawRoadButton.setImage(UIImage.init(named: "icon_directions"), for: .normal)
        drawRoadButton.isHidden = true
        drawRoadButton.addTarget(self, action: #selector(onPressRrawRoadButton), for: .touchUpInside)
        
        mapView.addSubview(drawRoadButton)
        mapView.bringSubview(toFront: drawRoadButton)
        
        // init LocationManager
        LocationManger.sharedLocationManager().startUpdateLocation { (result, error) in
            print(result as Any, error as Any)
        }
        // init tableView
        tableView.frame = mapView.frame
        tableView.register(UINib(nibName: "PlaceTableViewCell",bundle: nil), forCellReuseIdentifier: "PlaceTableViewCell")        
        // init segment
        segment.sizeToFit()
        segment.tintColor = COLOR.MAIN
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segControlChanged), for: .valueChanged)
        segment.frame = CGRect (x: 0 , y: mapView.bottom  , width: kScreenWidth , height: heightSegment )
    }
    
    func segControlChanged(segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.isHidden = false
        case 1:
            mapView.isHidden = true
        default:
            break
        }
    }
    
    func onPressRrawRoadButton(){
        guard  let _place = placeSelected else { return }
        self.drawRoadDirections(_place)
    }
    
    func onPressDirectionsButton(){
        guard  let _place = placeSelected else { return }
        self.drawRoadDirections(_place)
    }
    
    func onPressRightBarButton() {
        let filterView = FilterViewController()
        filterView.listCategory = self.listCategory
        navigationController?.present(filterView, animated: true, completion: nil)
    }
    
    func updateLayout(listPlace : [PlaceModel]){
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        for place in listPlace{
            let point = BMPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: Double(place.lat)!,
                                                      longitude: Double(place.lng)!)
            point.title     = place.title
            point.subtitle  = place.address
            point.place     = place
            self.mapView.addAnnotation(point)
        }
        self.tableView.reloadData()
    }
    
    func drawRoadDirections(_ place: PlaceModel){
        let point : CLLocationCoordinate2D =
            CLLocationCoordinate2D(latitude: Double(place.lat)!,
                                   longitude: Double(place.lng)!)
        self.getDirections(source: MKPlacemark(coordinate: curCoordinate!,
                                               addressDictionary: nil),
                           destination: MKPlacemark(coordinate: point,
                                                    addressDictionary: nil))
    }
    
    func getDirections(source: MKPlacemark, destination: MKPlacemark) {
        // create list MKMapItem
        let sourceMapItem = MKMapItem(placemark: source)
        let destinationMapItem = MKMapItem(placemark: destination)
        
        // create directionRequest
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // implemet directionRequest and add route
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            for step in route.steps{
                debugPrint( step.distance, "  " , step.instructions)
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Hide nav items
        navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Show nav items
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_filter"),
                                                            style: .plain, target: self,
                                                            action: #selector(onPressRightBarButton))
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //update layout
        self.updateLayout(listPlace: self.listPlace)
        return true
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension MapViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeView = PlaceViewController()
        placeView.place = listPlace [indexPath.row]
        navigationController?.pushViewController(placeView, animated: true)
    }
}

extension MapViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.adjustView(place: listPlace[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ place: PlaceModel){
        //update text at SearchBar when selected
        self.resultSearchController.searchBar.text = place.title
        let point : CLLocationCoordinate2D =
            CLLocationCoordinate2D(latitude: Double(place.lat)!,
                                  longitude: Double(place.lng)!)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(point, span)
        mapView.setRegion(region, animated: true)
    }
}
