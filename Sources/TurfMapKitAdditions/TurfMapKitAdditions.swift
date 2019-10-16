import MapKit
import Turf

public protocol RegionOnTheMap: MKOverlay {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool
}

public extension MultiPolygon {
    var polygons:[Polygon] { coordinates.map({ Polygon($0) }) }
}

public extension Ring {
    var boundingMapRect: MKMapRect { mapPoints.reduce(.null, { $0.union(MKMapRect(origin: $1, size: MKMapSize())) }) }
}

public extension GeoJSONObject {
    func property<T: LosslessStringConvertible>(_ propertyName: String, _ defaultValue: T) -> T {
        guard let properties = properties else { return defaultValue }
        if let value = properties[propertyName]?.jsonValue as? T {
            return value
        }
        if let strVal = properties[propertyName]?.jsonValue as? String, let result = T.init(strVal) {
            return result
        }
        return defaultValue
    }
}

public extension MultiPolygonFeature {
    static func +(lhs: MultiPolygonFeature, rhs: MultiPolygonFeature) -> MultiPolygonFeature {
        return MultiPolygonFeature(MultiPolygon(lhs.geometry.coordinates + rhs.geometry.coordinates))
    }
}
