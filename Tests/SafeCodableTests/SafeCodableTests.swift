import XCTest
@testable import SafeCodable

final class SafeCodableTests: XCTestCase {
    func testSafeType() {
        
        struct Book: Decodable {
            let year: Safe<Int, String>
            let name: String
        }
        
        let rawJson = """
        [
            {
                "year": 1951,
                "name": "Foundation"
            },
            {
                "year": "1984",
                "name": "Neuromancer"
            }
        ]
        """
        let decoder = JSONDecoder()
        let books = try? decoder.decode([Book].self, from: rawJson.data(using: .utf8)!)
        XCTAssertEqual(books?.last?.year.value, 1984)
    }

    func testSafeDates() {
        let rawDates = """
        [
            { "value" : "2015-08-29T11:22:09Z"},
            { "value" : "2015-08-29T11:22:09.129Z"},
            { "value" : "2020-11-27"}

        ]
        """.data(using: .utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601(extended: true)
        struct DateContainer: Decodable {
            let value: Date?
        }

        let dates = try? decoder.decode([DateContainer].self, from: rawDates!)
        XCTAssertEqual(dates?.count, 3)
    }
    
    static var allTests = [
        ("testSafeType", testSafeType), ("testSafeDates", testSafeDates)
    ]
}
