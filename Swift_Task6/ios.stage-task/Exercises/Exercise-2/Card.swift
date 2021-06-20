import Foundation

protocol CardBaseCompatible: Hashable, Codable {
    var suit: Suit {get}
    var value: Value {get}
    var isTrump: Bool {get}

    func hash(into hasher: inout Hasher)
}

enum Suit: Int, CaseIterable, Codable {
    case clubs
    case spades
    case hearts
    case diamonds
}

enum Value: Int, CaseIterable, Codable {
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace
}

struct Card: CardBaseCompatible {
    let suit: Suit
    let value: Value
    var isTrump: Bool = false

    func hash(into hasher: inout Hasher) {
        //создаем уникальный хэш по масти и значению
        hasher.combine(suit)
        hasher.combine(value)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        //сравниваем по хэшам значения масти и номанал
        return lhs.suit == rhs.suit && lhs.value == rhs.value
    }
}

extension Card {

    func checkIfCanBeat(card: Card) -> Bool {
        //тупой перебор вариантов, может ли карта покрыть другую карту
        if card.isTrump == false && self.isTrump == true { return true }
        if card.isTrump == true && self.isTrump == false { return false }
        if card.isTrump == true && self.isTrump == true && self.value.rawValue > card.value.rawValue { return true }
        if card.isTrump == true && self.isTrump == true && self.value.rawValue < card.value.rawValue { return false }
        if card.suit.rawValue == self.suit.rawValue && card.value.rawValue > self.value.rawValue { return false }
        if card.suit.rawValue == self.suit.rawValue && card.value.rawValue < self.value.rawValue { return true }
        if card.suit.rawValue != self.suit.rawValue { return false }
        return false
    }

    func checkValue(card: Card) -> Bool {
        //не пригодилось
        return false
    }
}
