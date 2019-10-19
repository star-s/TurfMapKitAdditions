//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19/10/2019.
//

#if canImport(UIKit)
import UIKit
import MapKit
import Turf

public extension MKOverlayRenderer {
    
    func makeBezierPath(shape: MultiPointShape) -> UIBezierPath {
        let path = UIBezierPath()
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
    
    func makeBezierPath(polygon: MKPolygon) -> UIBezierPath {
        let path = makeBezierPath(shape: polygon)
        for interior in polygon.interiorPolygons ?? [] {
            path.append(makeBezierPath(polygon: interior))
        }
        return path
    }
    
    func makeBezierPath(variant: FeatureVariant) -> UIBezierPath {
        switch variant {
        case .lineStringFeature(let line):
            return makeBezierPath(shape: line.geometry)
        case .polygonFeature(let feature):
            return makeBezierPath(featureGeometry: feature.geometry)
        case .multiPolygonFeature(let feature):
            return feature.geometry.polygons.map({ makeBezierPath(featureGeometry: $0) }).reduce(UIBezierPath(), { $0.append($1); return $0 })
        default:
            fatalError("wrong variant")
        }
    }
    
    func makeBezierPath(featureGeometry: Polygon) -> UIBezierPath {
        let path = makeBezierPath(shape: featureGeometry.outerRing)
        for ring in featureGeometry.innerRings ?? [] {
            path.append(makeBezierPath(shape: ring))
        }
        return path
    }
}
#endif
