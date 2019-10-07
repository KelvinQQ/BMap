//
//  MapViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/5.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import SnapKit

class MapViewController: UIViewController, MAMapViewDelegate {
    
    var gdMapView: MAMapView?
    lazy var searchView = UIView.init()
    lazy var searchButton = UIButton.init(type: UIButton.ButtonType.custom)
    lazy var leftButton = UIButton.init(type: UIButton.ButtonType.custom)
    lazy var locationButton = UIButton.init(type: .custom)
    lazy var zoomInButton = UIButton.init(type: .custom)
    lazy var zoomOutButton = UIButton.init(type: .custom)
    lazy var traficButton = UIButton.init(type: .custom)

    deinit {
        if let mapView = gdMapView {
            mapView.removeObserver(self, forKeyPath: "showsUserLocation")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        AMapServices.shared().enableHTTPS = true
        
        self.view.backgroundColor = UIColor.white
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.addObserver(self, forKeyPath: "showsUserLocation", options: NSKeyValueObservingOptions.new, context: nil)
        mapView.setZoomLevel(16, animated: true)
        self.gdMapView = mapView
        
        self.view.addSubview(self.searchView)
        self.searchView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(30)
            make.height.equalTo(50)
        }
        self.searchView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.leftButton)
        self.leftButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.searchView)
            make.left.equalTo(self.searchView).offset(20)
            make.height.equalTo(self.searchView)
            make.width.equalTo(self.leftButton.snp.height)
        }
        self.leftButton.backgroundColor = .red
        self.leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.leftButton.setImage(UIImage.init(named: "icon_menu"), for: .normal)
        
        self.searchView.addSubview(self.searchButton)
        self.searchButton.setTitle("搜索地点", for: .normal)
        self.searchButton.setTitleColor(UIColor.black, for: .normal)
        self.searchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.searchView)
            make.left.equalTo(self.searchView).offset(90)
            make.right.equalTo(self.searchView).offset(-10)
        }
        self.searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
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
        
        
    }
    
    @objc func leftButtonAction() {
        self.slideMenuController()?.toggleLeft()
    }
    
    @objc func searchAction() {
        let searchVc = SearchViewController.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    @objc func locationAction(sender: UIButton) {
        if let _ = self.gdMapView {
            
        }
    }
    
    @objc func traficAction(sender: UIButton) {
        if let mapView = self.gdMapView {
            mapView.isShowTraffic = !mapView.isShowTraffic
            sender.setTitle(mapView.isShowTraffic ? "开" : "关", for: .normal)
        }
    }
    
    @objc func zoomInAction() {
        if let mapView = self.gdMapView {
            guard mapView.zoomLevel > mapView.minZoomLevel else {
                return
            }
            mapView.setZoomLevel(max(mapView.zoomLevel - 1, mapView.minZoomLevel), animated: true)
        }
    }
    
    @objc func zoomOutAction() {
        if let mapView = self.gdMapView {
            guard mapView.zoomLevel < mapView.maxZoomLevel else {
                return
            }
            mapView.setZoomLevel(min(mapView.zoomLevel + 1, mapView.maxZoomLevel), animated: true)
        }
    }

    //MARK: - MAMapViewDelegate
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        
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
}

