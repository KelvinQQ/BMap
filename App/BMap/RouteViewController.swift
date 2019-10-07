//
//  RouteViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/6.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit

enum AMapRoutePlanningType {
    case drive,walk,bus,busCrossCity,riding,truck
}

class RouteViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {
    
    init(endPoi: AMapPOI, startPoi: AMapPOI?) {
        super.init(nibName: nil, bundle: nil)
        self.endPoi = endPoi
        if startPoi != nil {
            self.startPoi = startPoi
        }
        else {
//            startCoordinate = CLLocationCoordinate2DMake(39.910267, 116.370888)
//            self.startPoi =
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchAPI: AMapSearchAPI!
    var mapView: MAMapView!
    var startPoi: AMapPOI!
    var endPoi: AMapPOI!
//
    var naviRoute: MANaviRoute?
    var route: AMapRoute?
//    var currentSearchType: AMapRoutePlanningType = AMapRoutePlanningType.drive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)

        let request = AMapDrivingRouteSearchRequest()
        request.origin = self.startPoi.location
        request.destination = self.endPoi.location
        
        request.requireExtension = true
        
        
        searchAPI.aMapDrivingRouteSearch(request)

        
//        startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888)
//        destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956)
//
//        initMapView()
//        initSearch()
//        addDefaultAnnotations()
//
//        initToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
//    func addDefaultAnnotations() {
//
//        let anno = MAPointAnnotation()
//        anno.coordinate = startCoordinate
//        anno.title = "起点"
//
//        mapView.addAnnotation(anno)
//
//        let annod = MAPointAnnotation()
//        annod.coordinate = destinationCoordinate
//        annod.title = "终点"
//
//        mapView.addAnnotation(annod)
//    }
//
//    //MARK: - Action
//
//    @objc func searchTypeAction(sender: UISegmentedControl) {
//        currentSearchType = AMapRoutePlanningType(rawValue: sender.selectedSegmentIndex)!
//
//        startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888)
//        destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956)
//
//        switch currentSearchType {
//        case .drive:
//            searchRoutePlanningDrive()
//            break
//        case .walk:
//            searchRoutePlanningWalk()
//            break
//        case .bus:
//            searchRoutePlanningBus()
//            break
//        case .busCrossCity:
//
//            startCoordinate        = CLLocationCoordinate2DMake(40.818311, 111.670801)
//            destinationCoordinate  = CLLocationCoordinate2DMake(44.433942, 125.184449)
//
//            searchRoutePlanningBusCrossCity()
//            break
//        case .riding:
//            searchRoutePlanningRiding()
//            break
//        case .truck:
//            searchRoutePlanningTruck()
//            break;
//        }
//    }
//
//    func searchRoutePlanningDrive() {
//        let request = AMapDrivingRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        request.requireExtension = true
//
//        search.aMapDrivingRouteSearch(request)
//    }
//
//    func searchRoutePlanningWalk() {
//        let request = AMapWalkingRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        search.aMapWalkingRouteSearch(request)
//    }
//
//    func searchRoutePlanningBus() {
//        let request = AMapTransitRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        request.requireExtension = true
//        request.city = "北京"
//        search.aMapTransitRouteSearch(request)
//    }
//
//    func searchRoutePlanningBusCrossCity() {
//        let request = AMapTransitRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        request.requireExtension = true
//        request.city = "呼和浩特"
//        request.destinationCity = "农安县"
//        search.aMapTransitRouteSearch(request)
//    }
//
//    func searchRoutePlanningRiding() {
//        let request = AMapRidingRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        search.aMapRidingRouteSearch(request)
//    }
//    func searchRoutePlanningTruck() {
//        let request = AMapTruckRouteSearchRequest()
//        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
//
//        search.aMapTruckRouteSearch(request)
//    }
//
    /* 展示当前路线方案. */
    func presentCurrentCourse() {
//
//        let start = self.startPoi
//        let end = self.endPoi
//
//        if currentSearchType == .bus || currentSearchType == .busCrossCity {
//            naviRoute = MANaviRoute(for: route?.transits.first, start: start, end: end)
//        } else {
//            let type = MANaviAnnotationType(rawValue: currentSearchType.rawValue)
//
//            naviRoute = MANaviRoute(for: route?.paths.first, withNaviType: type!, showTraffic: true, start: start, end: end)
//        }
//        naviRoute = MANaviRoute(for: route?.transits.first, start: start, end: end)
//        naviRoute?.add(to: mapView)
//
//        mapView.showOverlays(naviRoute?.routePolylines, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
    }
//
//    //MARK: - MAMapViewDelegate
//
//    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
//
//        if overlay.isKind(of: LineDashPolyline.self) {
//            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
//            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
//            renderer.lineWidth = 8.0
//            renderer.strokeColor = UIColor.red
//            renderer.lineDashType = MALineDashType.square
//
//            return renderer
//        }
//        if overlay.isKind(of: MANaviPolyline.self) {
//
//            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
//            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
//            renderer.lineWidth = 8.0
//
//            if naviPolyline.type == MANaviAnnotationType.walking {
//                renderer.strokeColor = naviRoute?.walkingColor
//            }
//            else if naviPolyline.type == MANaviAnnotationType.railway {
//                renderer.strokeColor = naviRoute?.railwayColor;
//            }
//            else {
//                renderer.strokeColor = naviRoute?.routeColor;
//            }
//
//            return renderer
//        }
//        if overlay.isKind(of: MAMultiPolyline.self) {
//            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(multiPolyline: overlay as! MAMultiPolyline!)
//            renderer.lineWidth = 8.0
//            renderer.strokeColors = naviRoute?.multiPolylineColors
//
//            return renderer
//        }
//
//        return nil
//    }
//
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
//
//            if annotationView == nil {
//                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//                annotationView!.canShowCallout = true
//                annotationView!.isDraggable = false
//            }
//
//            annotationView!.image = nil
//
//            if annotation.isKind(of: MANaviAnnotation.self) {
//                let naviAnno = annotation as! MANaviAnnotation
//
//                switch naviAnno.type {
//                case MANaviAnnotationType.railway:
//                    annotationView!.image = UIImage(named: "railway_station")
//                    break
//                case MANaviAnnotationType.drive:
//                    annotationView!.image = UIImage(named: "car")
//                    break
//                case MANaviAnnotationType.riding:
//                    annotationView!.image = UIImage(named: "ride")
//                    break
//                case MANaviAnnotationType.walking:
//                    annotationView!.image = UIImage(named: "man")
//                    break
//                case MANaviAnnotationType.bus:
//                    annotationView!.image = UIImage(named: "bus")
//                    break
//                case .truck:
//                    annotationView!.image = UIImage(named: "truck")
//                    break
//                case .futureDrive:
//                    annotationView!.image = UIImage(named: "car")
//                    break
//                }
//            }
//            else {
//                if annotation.title == "起点" {
//                    annotationView!.image = UIImage(named: "startPoint")
//                }
//                else if annotation.title == "终点" {
//                    annotationView!.image = UIImage(named: "endPoint")
//                }
//            }
//            return annotationView!
//        }
//
//        return nil
//    }
//
    //MARK: - AMapSearchDelegate

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        let nsErr:NSError? = error as NSError
//        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
    }

    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

//        addDefaultAnnotations()

        self.route = nil
        if response.count > 0 {
            self.route = response.route
            presentCurrentCourse()
        }
    }

}
