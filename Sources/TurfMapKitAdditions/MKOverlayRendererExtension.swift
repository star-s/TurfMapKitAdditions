//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19/10/2019.
//

import MapKit
import Turf
#if canImport(UIKit)
import UIKit
public typealias BezierPath = UIBezierPath
#elseif canImport(AppKit)
import AppKit
import struct Turf.Polygon
public typealias BezierPath = NSBezierPath
#endif

public extension MKOverlayRenderer {
    
    func makeBezierPath(shape: MultiPointShape) -> BezierPath {
        let path = BezierPath()
        guard let begin = shape.beginMapPoint else { return path }
        path.move(to: point(for: begin))
        for mapPoint in shape.restMapPoints {
            path.addLine(to: point(for: mapPoint))
        }
        if shape.isClosedShape {
            path.close()
        }
        return path
    }
    
    func makeBezierPath(polygon: MKPolygon) -> BezierPath {
        let path = makeBezierPath(shape: polygon)
        for interior in polygon.interiorPolygons ?? [] {
            path.append(makeBezierPath(polygon: interior))
        }
        return path
    }
    
    func makeBezierPath(variant: FeatureVariant) -> BezierPath {
        switch variant {
        case .lineStringFeature(let line):
            return makeBezierPath(shape: line.geometry)
        case .polygonFeature(let feature):
            return makeBezierPath(featureGeometry: feature.geometry)
        case .multiPolygonFeature(let feature):
            return feature.geometry.polygons.map({ makeBezierPath(featureGeometry: $0) }).reduce(BezierPath(), { $0.append($1); return $0 })
        default:
            fatalError("wrong variant")
        }
    }
    
    func makeBezierPath(featureGeometry: Polygon) -> BezierPath {
        let path = makeBezierPath(shape: featureGeometry.outerRing)
        for ring in featureGeometry.innerRings ?? [] {
            path.append(makeBezierPath(shape: ring))
        }
        return path
    }
}
