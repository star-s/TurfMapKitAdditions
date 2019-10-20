//
//  MultiPointPathRenderer.swift
//  Map
//
//  Created by Sergey Starukhin on 15/10/2019.
//  Copyright © 2019 Sergey Starukhin. All rights reserved.
//

import MapKit
import Turf

public protocol MultiPointShapeOverlay: MKOverlay {
    var geometry: MultiPointShape { get }
}

open class MultiPointShapeRenderer: MKOverlayPathRenderer {
    
    override open func createPath() {
        switch overlay {
        case let overlay as MultiPointShapeOverlay:
            path = makeBezierPath(shape: overlay.geometry).cgPath
        case let shape as MultiPointShape:
            path = makeBezierPath(shape: shape).cgPath
        default:
            super.createPath()
        }
    }
}
