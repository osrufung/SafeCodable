# SafeCodable

![Swift](https://github.com/osrufung/SafeCodable/workflows/Swift/badge.svg)

Collection of Decodable extensions to help you when JSON responses safety is not guaranteed.


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
