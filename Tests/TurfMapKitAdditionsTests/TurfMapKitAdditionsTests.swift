import XCTest
@testable import TurfMapKitAdditions
import Turf
import CoreLocation

final class TurfMapKitAdditionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(TurfMapKitAdditions().text, "Hello, World!")
    }
    
    func testFeaturePropertyInt() {
        var point = PointFeature(Point(kCLLocationCoordinate2DInvalid))
        point.num = 42
        XCTAssertEqual(point.num, 42)
    }
    
    func testFeaturePropertyString() {
        var point = PointFeature(Point(kCLLocationCoordinate2DInvalid))
        point.str = "some string"
        XCTAssertEqual(point.str, "some string")
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}

extension PointFeature {
    var num: Int {
        get { property(#function) ?? -1 }
        set { setProperty(#function, newValue) }
    }
    var str: String {
        get { property(#function) ?? "" }
        set { setProperty(#function, newValue) }
    }
}
