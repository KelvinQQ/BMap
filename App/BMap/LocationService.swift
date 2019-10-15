//
//  LocationService.swift
//  BMap
//
//  Created by Tsing on 2019/10/12.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit

class LocationService: NSObject {
    static let `default` = LocationService()
    private override init() {}
    public var currentLocation: CLLocation?
}
