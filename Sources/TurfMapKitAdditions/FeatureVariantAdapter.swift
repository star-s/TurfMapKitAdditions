//
//  FeatureMapAdapter.swift
//  Map
//
//  Created by Sergey Starukhin on 15/10/2019.
//  Copyright © 2019 Sergey Starukhin. All rights reserved.
//

import Foundation
import MapKit
import Turf

public final class FeatureVariantAdapter: NSObject, RegionOnTheMap {
    public let variant: FeatureVariant
    
    public let coordinate: CLLocationCoordinate2D
    public let boundingMapRect: MKMapRect

    public var title: String? = nil
    public var subtitle: String? = nil

    public init(_ variant: FeatureVariant) {
        self.variant = variant
        switch variant {
        case .pointFeature(let point):
            boundingMapRect = MKMapRect(origin: MKMapPoint(point.geometry.coordinates), size: MKMapSize())
            coordinate = point.geometry.coordinates
        case .polygonFeature(let feature):
            boundingMapRect = feature.geometry.outerRing.boundingMapRect
            coordinate = MKCoordinateRegion(boundingMapRect).center
        case .multiPolygonFeature(let feature):
            boundingMapRect = feature.geometry.polygons.map({ $0.outerRing.boundingMapRect }).reduce(.null, { $0.union($1) })
            coordinate = MKCoordinateRegion(boundingMapRect).center
        default:
            coordinate = kCLLocationCoordinate2DInvalid
            boundingMapRect = MKMapRect.null
        }
    }
    /*
    convenience init(feature: PolygonFeature) {
        self.init(.polygonFeature(feature))
    }*/
    
    public func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        switch variant {
        case .pointFeature(let point):
            return point.geometry.coordinates == coordinate
        case .polygonFeature(let polygon):
            return polygon.geometry.contains(coordinate)
        case .multiPolygonFeature(let multyPolygon):
            return multyPolygon.geometry.polygons.map({ $0.contains(coordinate) }).reduce(false, { $0 || $1 })
        default:
            return false
        }
    }
}
