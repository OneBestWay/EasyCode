//
//  LocationManager.swift
//  SDemoN
//
//  Created by GK on 2017/3/6.
//  Copyright © 2017年 GK. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

typealias LocationCompletionHandler = ((_ latitude: Double, _ longitude: Double, _ status: String, _ verboseMessage: String, _ error: String?) -> ())?

typealias GeocodeCompletionHandler = ((_ gecodeInfo: NSDictionary?, _ placemark: CLPlacemark?, _ error: String?) -> ())?

typealias ReverseGeocodeCompletionHandler = ((_ reverseGecodeInfo: NSDictionary?, _ placemark: CLPlacemark? ,_ error: String?) -> ())?

enum GeoCodingType {
    case geocoding
    case reverseGeocoding
}

protocol LocationManagerDelegate: NSObjectProtocol {
    
    func locationFound(_ latitude: Double, longitude: Double)
    
    func locationFoundGetAsString(_ latitude: String, longitude: String)
    func locationManagerStatue(_ status: String)
    func locationManagerReceivedError(_ error: String)
    func locationManagerVerboseMessage(_ message: String)
}
class LocationManager: NSObject, CLLocationManagerDelegate {
    fileprivate var locationCompletionHandler: LocationCompletionHandler
    
    fileprivate var reverseGeocodingCompletionHandler: ReverseGeocodeCompletionHandler
    fileprivate var geocodingCompletionHandler: GeocodeCompletionHandler
    
    fileprivate var locationStatue: String = "Calibrating"
    fileprivate var locationManager: CLLocationDegrees!
    fileprivate var verboseMessage: String = "Calibrating"
    
    fileprivate let verboseMessageDictionary: Dictionary = [CLAuthorizationStatus.notDetermined:"还没有选择是否授权使用位置",
                                                            CLAuthorizationStatus.restricted:"应用不被授权使用位置，设备可能限制了定位服务，你不能改变或者你取消了堆该应用使用定位服务的授权",
                                                            CLAuthorizationStatus.denied:"你明确的取消了对该应用的授权，定位服务在设置中不可用",
                                                            CLAuthorizationStatus.authorizedAlways:"APP被授权使用定位服务",CLAuthorizationStatus.authorizedWhenInUse:"你已经授权了定位服务，并且只有APP正在使用时定位"]
    var delegate: LocationManagerDelegate? = nil
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var latitudeAsString: String = ""
    var longitudeAsString: String = ""
    
    var lastKnownLatitude: Double = 0.0
    var lastKnownLongitude: Double = 0.0
    
    var lastKnownLatitudeAsString:String = ""
    var lastKnownLongitudeAsString:String = ""
    
    var keepLastKnownLocation: Bool = true
    var hasLastKnownLocation: Bool = true
    
    var autoUpdate: Bool = false
    
    var showVerboseMessage = false
    
    var isRunning = false
    
    
    private override init() {
        super.init()
        
        if !autoUpdate {
            autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
    }
    private func resetLatLon() {
        
    }
    
    static let sharedInstance = LocationManager()
        
    
    
}
