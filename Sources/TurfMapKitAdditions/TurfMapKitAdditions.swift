import MapKit
import Turf

public extension MultiPolygon {
    var polygons:[Polygon] { coordinates.map({ Polygon($0) }) }
}

public extension Ring {
    func makeBoundingMapRect() -> MKMapRect { mapPoints.reduce(.null, { $0.union(MKMapRect(origin: $1, size: MKMapSize())) }) }
}

public extension GeoJSONObject {
    func property<T: LosslessStringConvertible>(_ propertyName: String) -> T? {
        guard let properties = properties else { return nil }
        if let value:T = properties[propertyName]?.unpackValue() {
            return value
        }
        return nil
    }
    
    mutating func setProperty(_ propertyName: String, _ value: JSONType) {
        if var prop = properties {
            prop[propertyName] = AnyJSONType(value.jsonValue)
            properties = prop
        } else {
            properties = [propertyName : AnyJSONType(value.jsonValue)]
        }
    }
}

public extension AnyJSONType {
    func unpackValue<T>() -> T? where T: LosslessStringConvertible {
        if let value = jsonValue as? T {
            return value
        }
        if let stringValue = jsonValue as? String {
            return T.init(stringValue)
        }
        return nil
    }
}

public extension FeatureVariant {
    func makeCoordinate() -> CLLocationCoordinate2D {
        switch self {
        case .pointFeature(let point):
            return point.geometry.coordinates
        case .polygonFeature(_), .multiPolygonFeature(_):
            return MKCoordinateRegion(makeBoundingMapRect()).center
        default:
            return kCLLocationCoordinate2DInvalid
        }
    }
    
    func makeBoundingMapRect() -> MKMapRect {
        switch self {
        case .pointFeature(let point):
            return MKMapRect(origin: MKMapPoint(point.geometry.coordinates), size: MKMapSize())
        case .polygonFeature(let feature):
            return feature.geometry.outerRing.makeBoundingMapRect()
        case .multiPolygonFeature(let feature):
            return feature.geometry.polygons.map({ $0.outerRing.makeBoundingMapRect() }).reduce(.null, { $0.union($1) })
        default:
            return .null
        }
    }
}
