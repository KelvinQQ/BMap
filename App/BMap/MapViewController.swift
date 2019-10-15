//
//  MapViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/5.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import SnapKit

class MapViewController: UIViewController, MAMapViewDelegate, MapNavigationViewDelegate, SearchNavigationViewDelegate, AMapSearchDelegate, POIsTableViewDelegate, SpeedTableViewDelegate {
    func didSelected(history: String) {
        
    }
    
    func didSelectedHome() {
        
    }
    
    func didSelectedCompany() {
        
    }
    
    func didSelected(poi: AMapPOI) {
        self.showPoisInMap(selected: poi)
    }
    
    func menuAction() {
        self.slideMenuController()?.toggleLeft()
    }
    
    func backAction() {
//        self.poisListView.clearView()
//        self.changeNavigationToMap()
//        if let mapView = self.gdMapView {
//            mapView.removeAnnotations(mapView.annotations)
//            mapView.setZoomLevel(16, animated: true)
//        }
    }
    
    func searchAction() {
        let searchVc = SearchViewController.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    func beginSearch(keyword: String) {
        
//        self.currentPage = 0
//
//        let request = AMapPOIKeywordsSearchRequest()
//        request.keywords = keyword
//        request.requireExtension = true
//        request.page = self.currentPage
//
//        self.searchAPI?.aMapPOIKeywordsSearch(request)
    }
    
    lazy var mapView: MAMapView = MAMapView.init(frame: .zero)
    lazy var mapNavigationView = MapNavigationView.init(frame: CGRect.zero)
//    lazy var searchNavigationView = SearchNavigationView.init(frame: CGRect.zero)
    lazy var searchView = UIView.init()

    lazy var locationButton = UIButton.init(type: .custom)
    lazy var zoomInButton = UIButton.init(type: .custom)
    lazy var zoomOutButton = UIButton.init(type: .custom)
    lazy var traficButton = UIButton.init(type: .custom)
    
//    lazy var searchAPI = AMapSearchAPI.init()
    
//    lazy var poisListView = POIsTableView.init(frame: .zero)
//    lazy var speedListView = SpeedTableView.init(frame: .zero)
    
    var currentPage = 0
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "showsUserLocation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        AMapServices.shared().enableHTTPS = true
        
        self.view.backgroundColor = UIColor.white
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow
        self.mapView.isShowTraffic = true
        self.mapView.addObserver(self, forKeyPath: "showsUserLocation", options: NSKeyValueObservingOptions.new, context: nil)
        self.mapView.setZoomLevel(16, animated: true)
        self.mapView.showsCompass = false
        
        self.changeNavigationToMap()
        
        let padding = 20
        let buttonHeight = 50
        
        let zoomView = UIView.init()
        self.view.addSubview(zoomView)
        zoomView.backgroundColor = UIColor.white
        zoomView.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-padding)
            make.bottom.equalTo(self.view).offset(-80)
            make.width.equalTo(buttonHeight)
        }
        
        zoomView.addSubview(self.zoomOutButton)
        self.zoomOutButton.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(zoomView)
            make.height.equalTo(self.zoomOutButton)
        }
        self.zoomOutButton.setTitle("+", for: .normal)
        self.zoomOutButton.setTitleColor(UIColor.black, for: .normal)
        self.zoomOutButton.addTarget(self, action: #selector(zoomOutAction), for: .touchUpInside)
        
        zoomView.addSubview(self.zoomInButton)
        self.zoomInButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.zoomOutButton.snp.bottom).offset(1)
            make.left.right.bottom.equalTo(zoomView)
            make.height.equalTo(self.zoomOutButton)
        }
        self.zoomInButton.setTitle("-", for: .normal)
        self.zoomInButton.setTitleColor(UIColor.black, for: .normal)
        self.zoomInButton.addTarget(self, action: #selector(zoomInAction), for: .touchUpInside)
        
        self.view.addSubview(self.traficButton)
        self.traficButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-padding)
            make.top.equalTo(self.view).offset(100)
            make.width.height.equalTo(buttonHeight)
        }
        self.traficButton.addTarget(self, action: #selector(traficAction(sender:)), for: .touchUpInside)
        self.traficButton.backgroundColor = .red
        
        self.view.addSubview(self.locationButton)
        self.locationButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(padding)
            make.bottom.equalTo(self.view).offset(-80)
            make.width.height.equalTo(buttonHeight)
        }
        self.locationButton.addTarget(self, action: #selector(locationAction(sender:)), for: .touchUpInside)
        self.locationButton.backgroundColor = .red
        
        self.mapNavigationView.delegate = self
//        self.searchNavigationView.delegate = self
//
//        self.searchAPI?.delegate = self
        
    }

    func changeNavigationToMap() {
        if self.mapNavigationView.superview == nil {
            self.view.addSubview(self.mapNavigationView)
            self.mapNavigationView.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(self.view).inset(UIEdgeInsets.init(top: 40, left: 20, bottom: 0, right: 20))
                make.height.equalTo(50)
            }
        }
        
        self.mapNavigationView.isHidden = false
//        self.searchNavigationView.isHidden = true
//        self.poisListView.isHidden = true
//        self.speedListView.isHidden = true
    }
    
    func changeNavigationToSearch() {
//        if self.searchNavigationView.superview == nil {
//            self.view.addSubview(self.searchNavigationView)
//            self.searchNavigationView.snp.makeConstraints { (make) in
//                make.left.right.top.equalTo(self.view).inset(UIEdgeInsets.init(top: 40, left: 20, bottom: 0, right: 20))
//                make.height.equalTo(50)
//            }
//        }
//
//        if self.speedListView.superview == nil {
//            self.view.addSubview(self.speedListView)
//            self.speedListView.delegate = self
//            self.speedListView.snp.makeConstraints { (make) in
//                make.left.right.equalTo(self.view)
//                make.top.equalTo(self.searchNavigationView.snp.bottom).offset(10)
//                make.bottom.equalTo(self.view)
//            }
//        }
//
//        self.mapNavigationView.isHidden = true
//        self.searchNavigationView.isHidden = false
//        self.poisListView.isHidden = true
//        self.speedListView.isHidden = false
    }
    
    @objc func locationAction(sender: UIButton) {
        mapView.userTrackingMode = MAUserTrackingMode(rawValue: (mapView.userTrackingMode.rawValue + 1) % 3)!
    }
    
    @objc func traficAction(sender: UIButton) {
        mapView.isShowTraffic = !mapView.isShowTraffic
        sender.setTitle(mapView.isShowTraffic ? "开" : "关", for: .normal)
    }
    
    @objc func zoomInAction() {
        guard mapView.zoomLevel > mapView.minZoomLevel else {
            return
        }
        mapView.setZoomLevel(max(mapView.zoomLevel - 1, mapView.minZoomLevel), animated: true)
    }
    
    @objc func zoomOutAction() {
        guard mapView.zoomLevel < mapView.maxZoomLevel else {
            return
        }
        mapView.setZoomLevel(min(mapView.zoomLevel + 1, mapView.maxZoomLevel), animated: true)
    }
    
    //MARK: - AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
//        if response.count == 0 {
//            return
//        }
//
//        if self.poisListView.superview == nil {
//            self.view.addSubview(self.poisListView)
//            self.poisListView.delegate = self
//            self.poisListView.snp.makeConstraints { (make) in
//                make.left.right.equalTo(self.view)
//                make.height.equalTo(250)
//                make.bottom.equalTo(self.view)
//            }
//        }
//
//        self.mapNavigationView.isHidden = true
//        self.searchNavigationView.isHidden = false
//        self.poisListView.isHidden = false
//        self.speedListView.isHidden = true
//
//        if self.currentPage == 0 {
//            self.poisListView.refreshView(pois: response.pois)
//        }
//        else {
//            self.poisListView.appendView(pois: response.pois)
//        }
    }

    //MARK: - MAMapViewDelegate
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        LocationService.default.currentLocation = mapView.userLocation.location
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MAMapView!) {
        LocationService.default.currentLocation = mapView.userLocation.location
    }
    
    //MARK: - NSKeyValueObservering
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath != nil) && (keyPath == "showsUserLocation") {
            let locationValue: NSNumber? = change?[NSKeyValueChangeKey.newKey] as! NSNumber?
            if locationValue != nil && locationValue!.boolValue {
//                locationSegmentControl.selectedSegmentIndex = 0
            }
            else {
//                locationSegmentControl.selectedSegmentIndex = 1
            }
            
        }
    }
    
    func showPoisInMap(selected: AMapPOI) {
    }
}

