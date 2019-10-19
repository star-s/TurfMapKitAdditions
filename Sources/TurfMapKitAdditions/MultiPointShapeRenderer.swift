//
//  MultiPointPathRenderer.swift
//  Map
//
//  Created by Sergey Starukhin on 15/10/2019.
//  Copyright © 2019 Sergey Starukhin. All rights reserved.
//

import UIKit
import MapKit
import Turf

open class MultiPointShapeRenderer: MKOverlayPathRenderer {
    
    override open func createPath() {
        switch overlay {
        case let polygon as MKPolygon:
            path = makeBezierPath(polygon: polygon).cgPath
        case let object as FeatureVariantAdapter:
            path = makeBezierPath(variant: object.variant).cgPath
        case let shape as MultiPointShape:
            path = makeBezierPath(shape: shape).cgPath
        default:
            super.createPath()
        }
    }
}
