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

open class FeatureVariantAdapter: NSObject, MKOverlay {
    public let variant: FeatureVariant
    
    public let coordinate: CLLocationCoordinate2D
    public let boundingMapRect: MKMapRect

    public init(_ variant: FeatureVariant) {
        self.variant = variant
        coordinate = variant.makeCoordinate()
        boundingMapRect = variant.makeBoundingMapRect()
    }
    /*
    convenience init(feature: PolygonFeature) {
        self.init(.polygonFeature(feature))
    }*/
    /*
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
    }*/
}
