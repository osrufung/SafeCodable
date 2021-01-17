public protocol Convertible {
    associatedtype Destination: Decodable
    var translated: Destination? { get }
}


extension String: Convertible {
    public var translated: Int? {
        return Int(self)
    }
}

public struct Safe<Base, Fallback: Convertible&Decodable>: Decodable where Fallback.Destination == Base {
    public let value: Base?
    
    public init(from decoder: Decoder)  {
        let container = try? decoder.singleValueContainer()
        if let base = try? container?.decode(Base.self) {
            value = base
        } else if let fallback = try? container?.decode(Fallback.self), let converted = fallback.translated {
            value = converted
        } else {
            value = nil
        }
        
    }
}


