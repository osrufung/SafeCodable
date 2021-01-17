import XCTest
@testable import SafeCodable


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



final class SafeCodableTests: XCTestCase {
    func testExample() {
        let decoder = JSONDecoder()
        let books = try? decoder.decode([Book].self, from: rawJson.data(using: .utf8)!)
        XCTAssertEqual(books?.last?.year.value, 1984)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
