# SafeCodable

![Swift](https://github.com/osrufung/SafeCodable/workflows/Swift/badge.svg)

Collection of Decodable extensions to help you when JSON responses safety is not guaranteed


## Feature

### Safe base/alternative types

```swift
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
let books = try decoder.decode([Book].self, from: rawJson.data(using: .utf8)!)

print(books.first?.year.value) //Optional(1951)
print(books.last?.year.value) //Optional(1984)
```
### Safe Date multi-format types

Some responses contains multiple types of Date formatting (iOS8601 with seconds, milliseconds or single dates)
```swift
let rawDates = """
[
    { "value" : "2015-08-29T11:22:09Z"},
    { "value" : "2015-08-29T11:22:09.129Z"},
    { "value" : "2020-11-27"},
    { "value" : "2019-08-03 23:59:59"}

]
""".data(using: .utf8)
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601(extended: true)
struct DateContainer: Decodable {
    let value: Date?
}

let dates = try? decoder.decode([DateContainer].self, from: rawDates!)
XCTAssertEqual(dates?.count, 4)
```
