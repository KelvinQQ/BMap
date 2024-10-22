//
//  RouteViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/6.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import AMapNaviKit

enum RoutePlanningType: Int {
    case drive = 0, riding, walk
}

class RouteTopView: UIView {
    
    lazy var originTextField = UITextField.init()
    lazy var destinationTextField = UITextField.init()
    
    init() {
        super.init(frame: .zero)
        let backButton = UIButton.init(type: .custom)
        self.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        self.addSubview(self.originTextField)
        self.originTextField.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.top.equalTo(backButton)
        }
        
        let lineView = UIView.init(frame: .zero)
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.originTextField)
            make.top.equalTo(self.originTextField.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        
        self.addSubview(self.destinationTextField)
        self.destinationTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.originTextField).offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(5)
        }
        
        let switchButton = UIButton.init(type: .custom)
        switchButton.backgroundColor = .red
        self.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
        }
        switchButton.addTarget(self, action: #selector(switchButtonAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonAction() {
        
    }
    
    @objc func switchButtonAction() {
        
    }
    
}

class RouteViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {
    
    private let AMapNaviRoutePolylineDefaultWidth = 30.0
    lazy var topView = RouteTopView.init()
    
   
    lazy var segmentView = BetterSegmentedControl.init(frame: .zero,
                                                       segments: LabelSegment.segments(withTitles: ["驾车","骑行","步行"],
                                                                                       normalFont: nil,
                                                                                       selectedFont: nil,
                                                                                       selectedTextColor: UIColor(red:0.20, green:0.68, blue:0.27, alpha:1.00)),
                                                       index: 0,
                                                       options: [.backgroundColor(.darkGray),
                                                                 .indicatorViewBackgroundColor(UIColor(red:0.55, green:0.26, blue:0.86, alpha:1.00)),
                                                                 .cornerRadius(3.0),
                                                                 .bouncesOnChange(false)])
    lazy var searchAPI = AMapSearchAPI.init()
    var mapView: MAMapView!
    var originPoi: AMapPOI?
    var destinationPoi: AMapPOI!
    lazy var currentLocation = LocationService.default.currentLocation
    
    init(destinationPoi: AMapPOI, originPoi: AMapPOI?) {
        super.init(nibName: nil, bundle: nil)
        self.destinationPoi = destinationPoi
        if originPoi != nil {
            self.originPoi = originPoi
        }
        AMapNaviDriveManager.sharedInstance().delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var naviRoute: MANaviRoute?
    var route: AMapRoute?
    var currentRoutePlanningType: RoutePlanningType = RoutePlanningType.drive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        self.view.addSubview(topView)
        self.topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(80)
        }
        
        self.view.addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(40)
        }
        segmentView.addTarget(self, action: #selector(segmentItemClick), for: .valueChanged)
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.segmentView.snp.bottom)
            make.bottom.equalTo(self.view)
        }

        self.searchRoutePlanningDrive()
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
    
    func addDefaultAnnotations() {

        let anno = MAPointAnnotation()
        if let originPoi = self.originPoi {
            anno.coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(originPoi.location.latitude), longitude: CLLocationDegrees(originPoi.location.longitude))
        }
        else {
            anno.coordinate = (self.currentLocation?.coordinate)!
        }
        anno.title = "起点"

        mapView.addAnnotation(anno)

        let annod = MAPointAnnotation()
        annod.coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(self.destinationPoi.location.latitude),
                                                       longitude: CLLocationDegrees(self.destinationPoi.location.longitude))
        annod.title = "终点"

        mapView.addAnnotation(annod)
    }

    func searchRoutePlanningDrive() {
                
        if let originPoint = self.originPoi {
            AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withStart: [AMapNaviPoint.location(withLatitude: originPoint.location.latitude, longitude: originPoint.location.longitude)],
                                                                      end: [AMapNaviPoint.location(withLatitude: self.destinationPoi.location.latitude, longitude: self.destinationPoi.location.longitude)],
                                                                      wayPoints: nil,
                                                                      drivingStrategy: AMapNaviDrivingStrategy.multipleAvoidHighwayAndCongestion)
        }
        else {
            AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withEnd: [AMapNaviPoint.location(withLatitude: self.destinationPoi.location.latitude, longitude: self.destinationPoi.location.longitude)],
                                                                      wayPoints: nil,
                                                                      drivingStrategy: AMapNaviDrivingStrategy.multipleAvoidHighwayAndCongestion)
        }
    }

    func searchRoutePlanningWalk() {
        let request = AMapWalkingRouteSearchRequest()
        if let originPoi = self.originPoi {
            request.origin = originPoi.location
        }
        else {
            request.origin = AMapGeoPoint.location(withLatitude: CGFloat((self.currentLocation?.coordinate.latitude)!),
                                                   longitude: CGFloat((self.currentLocation?.coordinate.longitude)!))
        }
        request.destination = self.destinationPoi.location
        searchAPI?.delegate = self
        searchAPI?.aMapWalkingRouteSearch(request)
    }

    func searchRoutePlanningRiding() {
        let request = AMapRidingRouteSearchRequest()
        if let originPoi = self.originPoi {
            request.origin = originPoi.location
        }
        else {
            request.origin = AMapGeoPoint.location(withLatitude: CGFloat((self.currentLocation?.coordinate.latitude)!),
                                                   longitude: CGFloat((self.currentLocation?.coordinate.longitude)!))
        }
        request.destination = self.destinationPoi.location
        searchAPI?.delegate = self
        searchAPI?.aMapRidingRouteSearch(request)
    }

    /* 展示当前路线方案. */
    func presentCurrentCourse() {

        let des = self.destinationPoi.location
        let ori = self.originPoi != nil ? self.originPoi!.location : AMapGeoPoint.location(withLatitude: CGFloat((self.currentLocation?.coordinate.latitude)!),longitude: CGFloat((self.currentLocation?.coordinate.longitude)!))

        let type = MANaviAnnotationType(rawValue: currentRoutePlanningType.rawValue)
        
        naviRoute = MANaviRoute(for: route?.paths.first, withNaviType: type!, showTraffic: true, start: ori, end: des)
        
        naviRoute?.add(to: mapView)

        mapView.showOverlays(naviRoute?.routePolylines, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }

    //MARK: - MAMapViewDelegate

    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {

        if overlay.isKind(of: MultiDriveRoutePolyline.self) {
            let polyline: MultiDriveRoutePolyline = overlay as! MultiDriveRoutePolyline
            let renderer: MAMultiTexturePolylineRenderer = MAMultiTexturePolylineRenderer.init(multiPolyline: polyline)
            renderer.lineWidth = CGFloat(AMapNaviRoutePolylineDefaultWidth)
            renderer.strokeTextureImages = polyline.polylineTextureImagesSeleted
            renderer.lineJoinType = kMALineJoinRound

            return renderer
        }

        return nil
    }

    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {

        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)

            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView!.canShowCallout = true
                annotationView!.isDraggable = false
            }

            annotationView!.image = nil

            if annotation.isKind(of: MANaviAnnotation.self) {
                let naviAnno = annotation as! MANaviAnnotation

                switch naviAnno.type {
                case MANaviAnnotationType.drive:
                    annotationView!.image = UIImage(named: "car")
                    break
                case MANaviAnnotationType.riding:
                    annotationView!.image = UIImage(named: "ride")
                    break
                case MANaviAnnotationType.walking:
                    annotationView!.image = UIImage(named: "man")
                    break
                }
            }
            else {
                if annotation.title == "起点" {
                    annotationView!.image = UIImage(named: "startPoint")
                }
                else if annotation.title == "终点" {
                    annotationView!.image = UIImage(named: "endPoint")
                }
            }
            return annotationView!
        }

        return nil
    }

    //MARK: - AMapSearchDelegate

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print(error.localizedDescription)
//        let nsErr:NSError? = error as NSError
//        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
    }

    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        addDefaultAnnotations()

        self.route = nil
        if response.count > 0 {
            self.route = response.route
            presentCurrentCourse()
        }
    }

    @objc func segmentItemClick() {
        currentRoutePlanningType = RoutePlanningType.init(rawValue: segmentView.index) ?? .drive
        switch currentRoutePlanningType {
        case .drive:
            searchRoutePlanningDrive()
        case .riding:
            searchRoutePlanningRiding()
        case .walk:
            searchRoutePlanningWalk()
        }
    }
}

extension RouteViewController: AMapNaviDriveManagerDelegate {
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        self.showNaviRoutes()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onCalculateRouteSuccessWith type: AMapNaviRoutePlanType) {
        
    }
    
    func showNaviRoutes() {
        guard let naviRoutes = AMapNaviDriveManager.sharedInstance().naviRoutes , naviRoutes.count > 0 else {
            return
        }

        self.mapView.remove(self.mapView!.overlays as? MAOverlay)

//        [self.routeIndicatorInfoArray removeAllObjects];
        var firstRouteId = 0
        for (routeId, route) in naviRoutes {
            firstRouteId = routeId.intValue
            let count = route.routeCoordinates.count
            let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: count)
            for i in 0..<count {
                let coordinate = route.routeCoordinates[i]
                coords[i].latitude = CLLocationDegrees(coordinate.latitude)
                coords[i].longitude = CLLocationDegrees(coordinate.longitude)
            }
            var textureImagesArrayNormal = [UIImage]()
            var textureImagesArraySelected = [UIImage]()
            
            for status in route.routeTrafficStatuses {
                let img = self.defaultTextureImage(routeStatus: status.status, selected: false)
                let selectedImg = self.defaultTextureImage(routeStatus: status.status, selected: true)
                if let img = img , let selectedImg = selectedImg {
                    textureImagesArrayNormal.append(img)
                    textureImagesArraySelected.append(selectedImg)
                }
            }
            
            let polyline = MultiDriveRoutePolyline.init(coordinates: coords, count: UInt(count), drawStyleIndexes: route.drawStyleIndexes)
            
            polyline?.polylineTextureImages = textureImagesArrayNormal
            polyline?.polylineTextureImagesSeleted = textureImagesArraySelected
            polyline?.routeID = routeId.intValue
            
            self.mapView.add(polyline)
            coords.deallocate()
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: false)
        self.mapView.showOverlays(self.mapView.overlays, edgePadding: UIEdgeInsets.zero, animated: true)
        self.selectNaviRoute(routeId: firstRouteId)
    }
    
    func selectNaviRoute(routeId: Int) -> Void {
        if AMapNaviDriveManager.sharedInstance().selectNaviRoute(withRouteID: routeId) {
            self.selecteOverlay(routeId: routeId)
        }
    }
    
    func selecteOverlay(routeId: Int) {
        var selectedPolylines = [MAOverlay]()
        let backupRoutePolylineWidthScale = 0.8
        for (_, overlay) in self.mapView.overlays.enumerated() {
            if (overlay as! MAOverlay).isKind(of: MultiDriveRoutePolyline.self) {
                let multiPolyline = overlay as! MultiDriveRoutePolyline
                let overlayRenderer = self.mapView.renderer(for: multiPolyline) as! MAMultiTexturePolylineRenderer
                if multiPolyline.routeID == routeId {
                    selectedPolylines.append(overlay as! MAOverlay)
                }
                else {
                    overlayRenderer.lineWidth = CGFloat(AMapNaviRoutePolylineDefaultWidth * backupRoutePolylineWidthScale)
                    overlayRenderer.strokeTextureImages = multiPolyline.polylineTextureImages
                }
            }
        }

        self.mapView.removeOverlays(selectedPolylines)
        self.mapView.addOverlays(selectedPolylines)
    }
    
    func defaultTextureImage(routeStatus: AMapNaviRouteStatus, selected: Bool) -> UIImage? {
        var imageName = ""
        switch routeStatus {
        case .smooth:
            imageName = "custtexture_green"
        case .slow:
            imageName = "custtexture_slow"
        case .jam:
            imageName = "custtexture_bad"
        case .seriousJam:
            imageName = "custtexture_serious"
        default:
            imageName = "custtexture_no"
        }

        if !selected {
            imageName = imageName + "_unselected"
        }
        
        let bundlePath = Bundle.main.path(forResource: "AMapNavi", ofType: "bundle")!
        imageName = "\(bundlePath)/nibs/\(imageName).png"
        let image = UIImage.init(named: imageName);
        return image
    }
}
