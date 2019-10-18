//
//  POIMapViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/12.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import FloatingPanel

extension POIMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poisArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellIdf, for: indexPath) as! SearchResultCell
        cell.updateCell(model: self.poisArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let endPoi = self.poisArray[indexPath.row]
        let routeVc = RouteViewController.init(destinationPoi: endPoi, originPoi: nil)
        self.navigationController?.pushViewController(routeVc, animated: true)
//        guard let delegate = self.delegate else {
//            return
//        }
//        delegate.didSelected(poi: self.poisArray[indexPath.row])
    }
}

extension POIMapViewController: MAMapViewDelegate {
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        
    }
}

class POIMapViewController: UIViewController {

    var fpc: FloatingPanelController!
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    public lazy var poisArray = [AMapPOI]()
    lazy var mapView: MAMapView = MAMapView.init(frame: .zero)
    
    init(pois: [AMapPOI]) {
        super.init(nibName: nil, bundle: nil)
        self.poisArray = pois
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.mapView.delegate = self
        self.mapView.isShowTraffic = true
        self.mapView.showsCompass = false
        
        let backButton = UIButton.init(type: .custom)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(30)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        backButton.backgroundColor = .red
        
        self.showPOIs()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(250)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellIdf)
    }
    
    var delegate: POIsTableViewDelegate?
    
    public func clearView() {
        self.poisArray = []
        self.tableView.reloadData()
    }
    
    func appendView(pois: [AMapPOI]) {
        self.poisArray += pois
        self.tableView.reloadData()
    }
    
    func refreshView(pois: [AMapPOI]) {
        self.poisArray = pois
        self.tableView.reloadData()
    }
    
    func showPOIs() {
        
        var annotations = Array<MAPointAnnotation>()
        
//        var selectedAnnotation = MAPointAnnotation()
        
        for poi in self.poisArray {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(poi.location.latitude), longitude: CLLocationDegrees(poi.location.longitude))
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = poi.name
            annotation.subtitle = poi.address
            annotations.append(annotation)
//            if selected.uid == poi.uid {
//                selectedAnnotation = annotation
//            }
        }
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, edgePadding: UIEdgeInsets.init(top: 0, left: 0, bottom: 250, right: 0), animated: true)
        mapView.selectAnnotation(annotations.first, animated: true)
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

class PoiListViewController: UIViewController {
    
}
