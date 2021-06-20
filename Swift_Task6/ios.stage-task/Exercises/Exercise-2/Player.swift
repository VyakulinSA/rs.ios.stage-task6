//
//  Player.swift
//  DurakGame
//
//  Created by Дима Носко on 15.06.21.
//

import Foundation

protocol PlayerBaseCompatible {
    var hand: [Card]? { get set }
}

final class Player: PlayerBaseCompatible {
    var hand: [Card]?

    func checkIfCanTossWhenAttacking(card: Card) -> Bool {
        //фильтруем все карты в руки с наименованием для подкидывания
        guard let tossArray = self.hand?.filter({ tossCard in
            return tossCard.value.rawValue == card.value.rawValue
        }) else { return false } //если нет, то возвращаем фолс
        return tossArray.count > 0 ? true : false
    }

    func checkIfCanTossWhenTossing(table: [Card: Card]) -> Bool {
        //фильтруем все карты в руки с наименованием для подкидывания, только внутри проверяем по словарю
        guard let tossArray = self.hand?.filter({ tossCard in
            for (key, value) in table{
                return tossCard.value.rawValue == key.value.rawValue || tossCard.value.rawValue == value.value.rawValue
            }
            return false
        }) else { return false }
        return tossArray.count > 0 ? true : false
    }
}
