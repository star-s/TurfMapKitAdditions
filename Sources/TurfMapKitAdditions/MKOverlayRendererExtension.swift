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

@nonobjc
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
        if let interiorShapes = shape.interiorShapes {
            interiorShapes.forEach({ path.append(makeBezierPath(shape: $0)) })
        }
        return path
    }
}
