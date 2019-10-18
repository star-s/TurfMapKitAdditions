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

public extension MultiPolygonFeature {
    static func +(lhs: MultiPolygonFeature, rhs: MultiPolygonFeature) -> MultiPolygonFeature {
        return MultiPolygonFeature(MultiPolygon(lhs.geometry.coordinates + rhs.geometry.coordinates))
    }
}
