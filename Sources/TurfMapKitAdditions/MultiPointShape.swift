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
}

public extension MultiPointShape {
    var beginMapPoint: MKMapPoint? { mapPoints.first }
    var restMapPoints: [MKMapPoint] { Array(mapPoints.suffix(from: 1)) }
    var interiorShapes: [MultiPointShape]? { nil }
}

extension MKMultiPoint: MultiPointShape {
    public var mapPoints: [MKMapPoint] { Array(UnsafeBufferPointer(start: points(), count: pointCount)) }
    public var isClosedShape: Bool {
        if let _ = self as? MKPolygon {
            return true
        }
        return false
    }
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
