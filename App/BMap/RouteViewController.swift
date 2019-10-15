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
    
    lazy var topView = RouteTopView.init()
    lazy var segmentView = BetterSegmentedControl.init(frame: .zero,
                                                       segments: [LabelSegment.init(text: "驾车"),
                                                                  LabelSegment.init(text: "骑行"),
                                                                  LabelSegment.init(text: "步行")],
                                                       index: 0,
                                                       options: nil)
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
        
//        let request = AMapDrivingRouteSearchRequest()
//
//        if let originPoi = self.originPoi {
//            request.origin = originPoi.location
//        }
//        else {
//            request.origin = AMapGeoPoint.location(withLatitude: CGFloat((self.currentLocation?.coordinate.latitude)!),
//                                                   longitude: CGFloat((self.currentLocation?.coordinate.longitude)!))
//        }
//        request.destination = self.destinationPoi.location
//        request.requireExtension = true
//        searchAPI?.delegate = self
//        searchAPI?.aMapDrivingRouteSearch(request)
//
//        AMapNaviDriveManager.sharedInstance().calculateDriveRoute(
//            withStart: [startPoint],
//            end: [endPoint],
//            wayPoints: nil,
//            drivingStrategy: 17)
        
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

        if overlay.isKind(of: LineDashPolyline.self) {
            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.red
            renderer.lineDashType = MALineDashType.square

            return renderer
        }
        if overlay.isKind(of: MANaviPolyline.self) {

            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0

            if naviPolyline.type == MANaviAnnotationType.walking {
                renderer.strokeColor = naviRoute?.walkingColor
            }
            else {
                renderer.strokeColor = naviRoute?.routeColor;
            }

            return renderer
        }
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(multiPolyline: overlay as! MAMultiPolyline!)
            renderer.lineWidth = 8.0
            renderer.strokeColors = naviRoute?.multiPolylineColors

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
//        driveManager.naviRoutes
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
        
        for (routeId, route) in naviRoutes {
            let count = route.routeCoordinates.count
//            let coords = malloc(count * 100) as! CLLocationCoordinate2D
            let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 1)
            for i in 0..<count {
                let coordinate = route.routeCoordinates[i]
                coords[i].latitude = CLLocationDegrees(coordinate.latitude)
                coords[i].longitude = CLLocationDegrees(coordinate.longitude)
            }
            let polyline = MAPolyline.init(coordinates: coords, count: UInt(count))
            let selectablePolyline = SelectableOverlay.init(overlay: polyline)
            selectablePolyline?.routeID = routeId.intValue
            self.mapView.add(selectablePolyline)
            coords.deallocate()
//            let info = Route
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: false)
//        self.select

//
//            //更新CollectonView的信息
//            RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
//            info.routeID = [aRouteID integerValue];
//            info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)[self.preferenceView strategyWithIsMultiple:self.isMultipleRoutePlan]];
//            info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
//
//            [self.routeIndicatorInfoArray addObject:info];
//        }
//
//        [self.mapView showAnnotations:self.mapView.annotations animated:NO];
//        [self.routeIndicatorView reloadData];
//
//        [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
    }
    
    func selectNaviRoute(routeId: Int) -> Void {
        if AMapNaviDriveManager.sharedInstance().selectNaviRoute(withRouteID: routeId) {
//            self.selectNaviRoute(routeId: <#T##Int#>)
        }
    }
    
//    - (void)selecteOverlayWithRouteID:(NSInteger)routeID
//    {
//    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
//    {
//    if ([overlay isKindOfClass:[SelectableOverlay class]])
//    {
//    SelectableOverlay *selectableOverlay = overlay;
//
//    /* 获取overlay对应的renderer. */
//    MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
//
//    if (selectableOverlay.routeID == routeID)
//    {
//    /* 设置选中状态. */
//    selectableOverlay.selected = YES;
//
//    /* 修改renderer选中颜色. */
//    overlayRenderer.fillColor   = selectableOverlay.selectedColor;
//    overlayRenderer.strokeColor = selectableOverlay.selectedColor;
//
//    /* 修改overlay覆盖的顺序. */
//    [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
//    }
//    else
//    {
//    /* 设置选中状态. */
//    selectableOverlay.selected = NO;
//
//    /* 修改renderer选中颜色. */
//    overlayRenderer.fillColor   = selectableOverlay.regularColor;
//    overlayRenderer.strokeColor = selectableOverlay.regularColor;
//    }
//    }
//    }];
//    }
    
//    - (void)selectNaviRouteWithID:(NSInteger)routeID
//    {
//    //在开始导航前进行路径选择
//    if ([[AMapNaviDriveManager sharedInstance] selectNaviRouteWithRouteID:routeID])
//    {
//    [self selecteOverlayWithRouteID:routeID];
//    }
//    else
//    {
//    NSLog(@"路径选择失败!");
//    }
//    }
}
