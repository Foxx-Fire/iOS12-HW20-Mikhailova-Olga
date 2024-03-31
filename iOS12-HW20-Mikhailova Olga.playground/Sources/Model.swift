import Foundation

//MARK: - Card
public struct CardCodes: Decodable {
    public let cards: [Card]
}

public struct Card: Decodable {
    public var name: String
    public var type: String
    public var types: [TypeElement]
    public var text: String
    public var manaCost: String?
    public var cardSet: String
    public var foreignNames: [ForeignName]?
    public var artist: String
    
    enum CodingKeys: String, CodingKey {
            case name, manaCost, type, types
            case cardSet = "set"
            case  text, artist, foreignNames
        }
}

public enum TypeElement: String, Codable {
    case artifact = "Artifact"
    case creature = "Creature"
    case enchantment = "Enchantment"
    case instant = "Instant"
    case plane = "Plane"
}

public struct ForeignName: Codable {
    let name: String
    let language: Language
    
    enum CodingKeys: String, CodingKey {
        case name
        case language
    }
}

enum Language: String, Codable {
    case chineseSimplified = "Chinese Simplified"
    case chineseTraditional = "Chinese Traditional"
    case french = "French"
    case german = "German"
    case italian = "Italian"
    case japanese = "Japanese"
    case korean = "Korean"
    case portugueseBrazil = "Portuguese (Brazil)"
    case russian = "Russian"
    case spanish = "Spanish"
}


