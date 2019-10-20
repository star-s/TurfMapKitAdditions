//
//  MultiPointShape.swift
//  Map
//
//  Created by Sergey Starukhin on 15/10/2019.
//  Copyright © 2019 Sergey Starukhin. All rights reserved.
//

import Foundation
import MapKit
import Turf

public protocol MultiPointShape {
    var mapPoints: [MKMapPoint] { get }
    var isClosedShape: Bool { get }
    
    var interiorShapes: [MultiPointShape]? { get }
    
    var beginMapPoint: MKMapPoint? { get }
    var restMapPoints: [MKMapPoint] { get }
    
    var bounds: MKMapRect { get }
}

public extension MultiPointShape {
    var beginMapPoint: MKMapPoint? { mapPoints.first }
    var restMapPoints: [MKMapPoint] { Array(mapPoints.suffix(from: 1)) }
    var interiorShapes: [MultiPointShape]? { nil }
    
    var bounds: MKMapRect {
        let result = mapPoints.reduce(MKMapRect.null, { $0.union(MKMapRect(origin: $1, size: MKMapSize())) })
        if let interior = interiorShapes {
            return interior.map({ $0.bounds }).reduce(result, { $0.union($1) })
        }
        return result
    }
}

extension MKMultiPoint: MultiPointShape {
    public var mapPoints: [MKMapPoint] { Array(UnsafeBufferPointer(start: points(), count: pointCount)) }
    public var isClosedShape: Bool { self is MKPolygon }
    public var interiorShapes: [MultiPointShape]? {
        if let polygon = self as? MKPolygon {
            return polygon.interiorPolygons
        }
        return nil
    }
}

extension Ring: MultiPointShape {
    public var mapPoints: [MKMapPoint] { coordinates.map({ MKMapPoint($0) }) }
    public var isClosedShape: Bool { true }
}

extension LineString: MultiPointShape {
    public var mapPoints: [MKMapPoint] { coordinates.map({ MKMapPoint($0) }) }
    public var isClosedShape: Bool { false }
}

extension Polygon: MultiPointShape {
    public var mapPoints: [MKMapPoint] { outerRing.mapPoints }
    public var isClosedShape: Bool { true }
    public var interiorShapes: [MultiPointShape]? { innerRings }
}
